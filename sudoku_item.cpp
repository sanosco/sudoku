#include <thread>
#include <QDir>
#include <QRandomGenerator>

#include "sudoku_item.h"

SudokuItem::SudokuItem(QObject *parent) : QObject(parent), m_matrix(81, '*'), m_puzzle(81, '*'), m_board(81, '*')
{

}

QString SudokuItem::get_puzzle()
{
    return m_puzzle;
}

void SudokuItem::set_puzzle(const QString& puzzle)
{
    m_puzzle = puzzle;
}

QString SudokuItem::get_board()
{
    return m_board;
}

void SudokuItem::set_board(const QString& board)
{
    m_board = board;
}

bool SudokuItem::get_hints_were_enabled()
{
    return m_hints_were_enabled;
}

void SudokuItem::set_hints_were_enabled(bool flag)
{
    m_hints_were_enabled = flag;
}

bool SudokuItem::get_score_is_recorded()
{
    return m_score_is_recorded;
}

void SudokuItem::set_score_is_recorded(bool flag)
{
    m_score_is_recorded = flag;
}

bool SudokuItem::get_board_was_completed()
{
    return m_board_was_completed;
}

void SudokuItem::set_board_was_completed(bool flag)
{
    m_board_was_completed = flag;
}

void SudokuItem::store_config(QString config)
{
    ensure_sudoku_dir();

    QString path = QDir::homePath() + "/" SUDOKU_CONFIG_FILE_PATH;
    QFile file(path);

    if (file.open(QIODevice::WriteOnly))
    {
        auto content = config.toUtf8();
        file.write(content.data(), content.size());
    }
}

QString SudokuItem::restore_config()
{
    QString config;

    QString path = QDir::homePath() + "/" SUDOKU_CONFIG_FILE_PATH;
    QFile file(path);

    if (file.exists())
    {
        if (file.open(QIODevice::ReadOnly))
        {
            QByteArray content;
            content.resize(static_cast<int>(file.size()));
            file.read(content.data(), content.size());
            config = QString::fromUtf8(content);
        }
    }

    return config;
}

void SudokuItem::store_scores()
{
    ensure_sudoku_dir();

    QString path = QDir::homePath() + "/" SUDOKU_SCORE_FILE_PATH;
    QFile file(path);

    if (file.open(QIODevice::WriteOnly))
    {
        unsigned char flags = 0;

        if (m_hints_were_enabled)
            flags |= 0x1;

        if (m_score_is_recorded)
            flags |= 0x2;

        const char* p = reinterpret_cast<const char*>(&flags);
        file.write(p, sizeof(flags));

        write_score(file, m_score_without_hints);
        write_score(file, m_score_with_hints);
    }
}

void SudokuItem::restore_scores()
{
    QString path = QDir::homePath() + "/" SUDOKU_SCORE_FILE_PATH;
    QFile file(path);

    if (file.exists())
    {
        if (file.open(QIODevice::ReadOnly))
        {
            unsigned char flags = 0;

            char* p = reinterpret_cast<char*>(&flags);
            file.read(p, sizeof(flags));

            m_hints_were_enabled = flags & 0x1;
            m_score_is_recorded = flags & 0x2;

            read_score(file, m_score_without_hints);
            read_score(file, m_score_with_hints);
        }
    }
}

void SudokuItem::store_board()
{
    ensure_sudoku_dir();

    QString path = QDir::homePath() + "/" SUDOKU_GAME_FILE_PATH;
    QFile file(path);

    if (file.open(QIODevice::WriteOnly))
    {
        std::array<quint32, 21> keys;
        QRandomGenerator::global()->generate(keys.begin(), keys.end());

        const char* key = reinterpret_cast<const char*>(keys.data());
        auto mstr = m_matrix.toStdString();
        auto pstr = m_puzzle.toStdString();
        auto bstr = m_board.toStdString();
        const char* matrix = mstr.c_str();
        const char* puzzle = pstr.c_str();
        const char* board = bstr.c_str();

        for (unsigned p = 0; p < Sudoku::pos_num; ++p)
        {
            char buff[4];
            buff[0] = key[p];
            buff[1] = matrix[p] ^ buff[0];
            buff[2] = puzzle[p] ^ buff[0];
            buff[3] = board[p] ^ buff[0];
            file.write(buff, sizeof(buff));
        }
    }
}

bool SudokuItem::restore_board()
{
    QString path = QDir::homePath() + "/" SUDOKU_GAME_FILE_PATH;
    QFile file(path);

    if (!file.exists())
        return false;

    if (!file.open(QIODevice::ReadOnly))
        return false;

    m_marked_contradicting_positions.clear();

    for (unsigned p = 0; p < Sudoku::pos_num; ++p)
    {
        char buff[4];
        file.read(buff, sizeof(buff));
        m_matrix[p] = buff[1] ^ buff[0];
        m_puzzle[p] = buff[2] ^ buff[0];
        m_board[p] = buff[3] ^ buff[0];

        if (m_board[p] == Sudoku::blank)
        {
            ++m_hidden_count;
        }
    }

    return true;
}

void SudokuItem::remove_board()
{
    QString path = QDir::homePath() + "/" SUDOKU_GAME_FILE_PATH;
    QFile file(path);

    if (!file.exists())
        return;

    file.remove();
}

void SudokuItem::create_new_puzzle(uint lvl)
{
    std::thread(&SudokuItem::generate_new_puzzle, this, lvl).detach();
}

void SudokuItem::set_value(uint pos, QString val)
{
    if (val[0] == Sudoku::blank)
    {
        if (m_board[pos] == Sudoku::blank)
        {
            return;
        }
        else
        {
            ++m_hidden_count;
        }
    }
    else if (m_board[pos] == Sudoku::blank)
    {
        --m_hidden_count;
    }

    m_board[pos] = val[0];
}

bool SudokuItem::check_value(uint pos, QString val)
{
    char value = val.toStdString().c_str()[0];

    if (value == Sudoku::blank)
        return true;

    uint i = pos / 9;
    uint j = pos % 9;

    for (uint l = 0; l < 9; ++l)
    {
        // check line
        uint current = 9 * i + l;
        if (current != pos && m_board[current] == value)
            return false;

        // check column
        current = 9 * l + j;
        if (current != pos && m_board[current] == value)
            return false;

        // check block
        uint k = 3 * (i / 3) + l / 3;
        uint m = 3 * (j / 3) + l % 3;
        current = 9 * k + m;
        if (current != pos && m_board[current] == value)
            return false;
    }

    return true;
}

void SudokuItem::check_entered_position(uint pos)
{
    check_marked_contradicting_positions();

    auto contradictions = check_contradicting_position(pos);

    for (auto p : contradictions)
    {
        mark_contradicting_position(p, true);
    }
}

void SudokuItem::clear_marked_contradicting_positions()
{
    for (auto p : m_marked_contradicting_positions)
    {
        emit contradictingPositionChecked(p, false);
    }

    m_marked_contradicting_positions.clear();
}

void SudokuItem::check_board()
{
    clear_marked_contradicting_positions();

    for (uint pos = 0; pos < Sudoku::pos_num; ++pos)
    {
        if (m_marked_contradicting_positions.count(pos) == 0)
        {
            auto contradictions = check_contradicting_position(pos);

            for (auto p : contradictions)
            {
                mark_contradicting_position(p, true);
            }
        }
    }
}

void SudokuItem::highlight_related_positions(uint pos, bool highlight)
{
    uint i = pos / 9;
    uint j = pos % 9;

    for (uint l = 0; l < 9; ++l)
    {
        // line
        uint current = 9 * i + l;
        if (current != pos)
        {
            highlight_related_position(current, highlight);
        }

        // column
        current = 9 * l + j;
        if (current != pos)
        {
            highlight_related_position(current, highlight);
        }

        // block
        uint k = 3 * (i / 3) + l / 3;
        uint m = 3 * (j / 3) + l % 3;
        current = 9 * k + m;
        if (current != pos)
        {
            highlight_related_position(current, highlight);
        }
    }

    highlight_related_position(pos, highlight);
}

bool SudokuItem::is_completed()
{
    return m_hidden_count == 0;
}

bool SudokuItem::check_solution()
{
    return m_board == m_matrix;
}

QString SudokuItem::get_current_game_profile_string()
{
    unsigned hidden_count = get_puzzle_hidden_positon_count();
    return QString::number(hidden_count) + " / " + QString::number(Sudoku::pos_num - hidden_count);
}

void SudokuItem::update_scores(bool success)
{
    unsigned hidden_count = get_puzzle_hidden_positon_count();
    auto& record = m_hints_were_enabled ? m_score_with_hints[hidden_count] : m_score_without_hints[hidden_count];

    if (success)
    {
        if (!m_score_is_recorded)
        {
            ++record.count_of_win;
            m_score_is_recorded = true;
        }
    }
    else
    {
        if (!m_score_is_recorded)
        {
            ++record.count_of_lose;
        }
    }
}

void SudokuItem::start_score_listing_without_hints()
{
    m_current_score_record_without_hints = m_score_without_hints.cbegin();
}

QVariantMap SudokuItem::get_current_score_record_without_hints()
{
    QVariantMap result;
    if (m_current_score_record_without_hints == m_score_without_hints.cend())
    {
        result.insert("fwd", false);
        return result;
    }

    unsigned complexity = m_current_score_record_without_hints->first;
    unsigned wins = m_current_score_record_without_hints->second.count_of_win;
    unsigned loses = m_current_score_record_without_hints->second.count_of_lose;

    result.insert("fwd", true);
    result.insert("complexity", complexity);
    result.insert("wins", wins);
    result.insert("loses", loses);

    ++m_current_score_record_without_hints;
    return result;
}

void SudokuItem::start_score_listing_with_hints()
{
    m_current_score_record_with_hints = m_score_with_hints.cbegin();
}

QVariantMap SudokuItem::get_current_score_record_with_hints()
{
    QVariantMap result;
    if (m_current_score_record_with_hints == m_score_with_hints.cend())
    {
        result.insert("fwd", false);
        return result;
    }

    unsigned complexity = m_current_score_record_with_hints->first;
    unsigned wins = m_current_score_record_with_hints->second.count_of_win;
    unsigned loses = m_current_score_record_with_hints->second.count_of_lose;

    result.insert("fwd", true);
    result.insert("complexity", complexity);
    result.insert("wins", wins);
    result.insert("loses", loses);

    ++m_current_score_record_with_hints;
    return result;
}

void SudokuItem::generate_new_puzzle(uint lvl)
{
    if (m_generating_flag.test_and_set())
        return;

    clear_marked_contradicting_positions();

    m_board.clear();
    m_puzzle.clear();
    m_hidden_count = 0;

    m_sudoku.make_matrix();
    m_sudoku.make_puzzle();

    switch (lvl)
    {
        case 0:
            m_sudoku.select_easy();
            break;

        case 1:
            m_sudoku.select_medium();
            break;

        case 2:
            m_sudoku.select_hard();
            break;

        case 3:
        default:
            m_sudoku.select_expert();
            break;
    }

    const auto& matrix = m_sudoku.get_matrix();
    const auto& puzzle = m_sudoku.get_puzzle();

    for (unsigned i = 0; i < 9; ++i)
    {
        for (unsigned j = 0; j < 9; ++j)
        {
            unsigned pos = 9 * i + j;
            m_matrix[pos] = matrix[i][j];
            m_puzzle[pos] = puzzle[i][j];
            m_board[pos] = puzzle[i][j];

            if (puzzle[i][j] == Sudoku::blank)
            {
                ++m_hidden_count;
            }
        }
    }

    m_generating_flag.clear();
    emit newGameCreated();
}

void SudokuItem::ensure_sudoku_dir()
{
    QString path = QDir::homePath() + "/" USER_SUDOKU_DIR;
    QDir dir(path);

    if (!dir.exists())
        dir.mkpath(path);
}

void SudokuItem::mark_contradicting_position(uint pos, bool mark)
{
    if (mark)
    {
        if (m_marked_contradicting_positions.count(pos) == 0)
        {
            m_marked_contradicting_positions.insert(pos);
            emit contradictingPositionChecked(pos, mark);
        }
    }
    else
    {
        if (m_marked_contradicting_positions.count(pos))
        {
            m_marked_contradicting_positions.erase(pos);
            emit contradictingPositionChecked(pos, mark);
        }
    }
}

std::vector<uint> SudokuItem::check_contradicting_position(uint pos)
{
    std::vector<uint> contradictions;

    auto value = m_board[pos];

    if (value == Sudoku::blank)
        return contradictions;

    uint i = pos / 9;
    uint j = pos % 9;

    bool inconsistency = false;

    for (uint l = 0; l < 9; ++l)
    {
        // check line
        uint current = 9 * i + l;
        if (current != pos && m_board[current] == value)
        {
            inconsistency = true;
            contradictions.push_back(current);
        }

        // check column
        current = 9 * l + j;
        if (current != pos && m_board[current] == value)
        {
            inconsistency = true;
            contradictions.push_back(current);
        }

        // check block
        uint k = 3 * (i / 3) + l / 3;
        uint m = 3 * (j / 3) + l % 3;
        current = 9 * k + m;
        if (current != pos && m_board[current] == value)
        {
            inconsistency = true;
            contradictions.push_back(current);
        }
    }

    if (inconsistency)
        contradictions.push_back(pos);

    return contradictions;
}

void SudokuItem::check_marked_contradicting_positions()
{
    std::vector<uint> positions_to_unmark;

    for (auto p : m_marked_contradicting_positions)
    {
        auto contradictions = check_contradicting_position(p);

        if (contradictions.size() == 0)
        {
            positions_to_unmark.push_back(p);
        }
    }

    for (auto p : positions_to_unmark)
    {
        mark_contradicting_position(p, false);
    }
}

void SudokuItem::highlight_related_position(uint pos, bool highlight)
{
    emit relatedPositionHighlighted(pos, highlight);
}

unsigned SudokuItem::get_puzzle_hidden_positon_count()
{
    unsigned hidden_count = 0;

    for (auto ch : m_puzzle)
    {
        if (ch == Sudoku::blank)
        {
            ++hidden_count;
        }
    }

    return hidden_count;
}

void SudokuItem::write_score(QFile &file, const SudokuItem::score_map_t &scores)
{
    std::size_t count = scores.size();
    const char* p = reinterpret_cast<const char*>(&count);
    file.write(p, sizeof(count));

    for (const auto& r : scores)
    {
        struct
        {
            unsigned complexity;
            unsigned count_of_win;
            unsigned count_of_lose;
        } __attribute__((packed)) record;

        record.complexity = r.first;
        record.count_of_win = r.second.count_of_win;
        record.count_of_lose = r.second.count_of_lose;

        p = reinterpret_cast<const char*>(&record);
        file.write(p, sizeof(record));
    }
}

void SudokuItem::read_score(QFile &file, SudokuItem::score_map_t &scores)
{
    std::size_t count = 0;
    char* p = reinterpret_cast<char*>(&count);
    file.read(p, sizeof(count));

    for (std::size_t i = 0; i < count; ++i)
    {
        struct
        {
            unsigned complexity;
            unsigned count_of_win;
            unsigned count_of_lose;
        } __attribute__((packed)) record;

        p = reinterpret_cast<char*>(&record);
        file.read(p, sizeof(record));

        scores[record.complexity] = {record.count_of_win, record.count_of_lose};
    }
}
