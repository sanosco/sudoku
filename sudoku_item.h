#ifndef SUDOKU_ITEM_H
#define SUDOKU_ITEM_H

#include <atomic>
#include <set>
#include <QObject>
#include <QVariant>
#include <QFile>

#include "isudoku.h"

#define USER_SUDOKU_DIR ".sudoku"
#define SUDOKU_GAME_FILE "sudoku.game"
#define SUDOKU_CONFIG_FILE "sudoku.config"
#define SUDOKU_SCORE_FILE "sudoku.score"
#define SUDOKU_GAME_FILE_PATH USER_SUDOKU_DIR "/" SUDOKU_GAME_FILE
#define SUDOKU_CONFIG_FILE_PATH USER_SUDOKU_DIR "/" SUDOKU_CONFIG_FILE
#define SUDOKU_SCORE_FILE_PATH USER_SUDOKU_DIR "/" SUDOKU_SCORE_FILE

class SudokuItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString puzzle READ get_puzzle WRITE set_puzzle NOTIFY puzzleChanged)
    Q_PROPERTY(QString board READ get_board WRITE set_board NOTIFY boardChanged)
    Q_PROPERTY(bool hints_were_enabled READ get_hints_were_enabled WRITE set_hints_were_enabled NOTIFY hintsWereEnabledChanged)
    Q_PROPERTY(bool score_is_recorded READ get_score_is_recorded WRITE set_score_is_recorded NOTIFY scoreIsRecordedChanged)
    Q_PROPERTY(bool board_was_completed READ get_board_was_completed WRITE set_board_was_completed NOTIFY boardWasCompletedChanged)

public:
    explicit SudokuItem(QObject* parent = nullptr);

    QString get_puzzle();
    void set_puzzle(const QString& puzzle);

    QString get_board();
    void set_board(const QString& board);

    bool get_hints_were_enabled();
    void set_hints_were_enabled(bool flag);

    bool get_score_is_recorded();
    void set_score_is_recorded(bool flag);

    bool get_board_was_completed();
    void set_board_was_completed(bool flag);

public:
    Q_INVOKABLE void store_config(QString config);
    Q_INVOKABLE QString restore_config();
    Q_INVOKABLE void store_scores();
    Q_INVOKABLE void restore_scores();
    Q_INVOKABLE void store_board();
    Q_INVOKABLE bool restore_board();
    Q_INVOKABLE void remove_board();
    Q_INVOKABLE void create_new_puzzle(uint lvl);
    Q_INVOKABLE void set_value(uint pos, QString val);
    Q_INVOKABLE bool check_value(uint pos, QString val);
    Q_INVOKABLE void check_entered_position(uint pos);
    Q_INVOKABLE void clear_marked_contradicting_positions();
    Q_INVOKABLE void check_board();
    Q_INVOKABLE void highlight_related_positions(uint pos, bool highlight);
    Q_INVOKABLE bool is_completed();
    Q_INVOKABLE bool check_solution();
    Q_INVOKABLE QString get_current_game_profile_string();
    Q_INVOKABLE void update_scores(bool success);
    Q_INVOKABLE void clear_scores();
    Q_INVOKABLE void start_score_listing_without_hints();
    Q_INVOKABLE QVariantMap get_current_score_record_without_hints();
    Q_INVOKABLE void start_score_listing_with_hints();
    Q_INVOKABLE QVariantMap get_current_score_record_with_hints();

signals:
    void puzzleChanged();
    void boardChanged();
    void hintsWereEnabledChanged();
    void scoreIsRecordedChanged();
    void boardWasCompletedChanged();
    void newGameCreated();
    void contradictingPositionChecked(uint cell, bool marked);
    void relatedPositionHighlighted(uint cell, bool highlighted);

public slots:

private:
    struct score
    {
        unsigned count_of_win;
        unsigned count_of_lose;
    };

    // statistics map: count of hidden positions <--> score
    using score_map_t = std::map<unsigned, score>;

private:
    void generate_new_puzzle(uint lvl);
    void ensure_sudoku_dir();
    void mark_contradicting_position(uint pos, bool mark);
    std::vector<uint> check_contradicting_position(uint pos);
    void check_marked_contradicting_positions();
    void highlight_related_position(uint pos, bool highlight);
    unsigned get_puzzle_hidden_positon_count();
    void write_score(QFile& file, const score_map_t& scores);
    void read_score(QFile& file, score_map_t& scores);

private:
    QString m_matrix;
    QString m_puzzle;
    QString m_board;
    sudoku_ptr_t m_sudoku;
    size_t m_hidden_count = 0;
    std::set<uint> m_marked_contradicting_positions;
    score_map_t m_score_without_hints;
    score_map_t::const_iterator m_current_score_record_without_hints;
    score_map_t m_score_with_hints;
    score_map_t::const_iterator m_current_score_record_with_hints;
    bool m_hints_were_enabled = false;
    bool m_score_is_recorded = false;
    bool m_board_was_completed = false;
    std::atomic_flag m_generating_flag = ATOMIC_FLAG_INIT;
};

#endif // SUDOKU_ITEM_H
