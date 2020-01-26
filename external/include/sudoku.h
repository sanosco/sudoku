#ifndef SUDOKU_H
#define SUDOKU_H

#include <cstdlib>
#include <cstring>

#include <vector>
#include <set>
#include <map>

class Sudoku
{
public:
    static constexpr size_t pos_num =  9 * 9;
    static constexpr char blank = '*';
    using matrix_t = char[9][9];

public:
    Sudoku();

    void make_matrix();
    void make_puzzle();

    void select_easy();
    void select_medium();
    void select_hard();
    void select_expert();

    const matrix_t& get_matrix() const;
    const matrix_t& get_puzzle() const;

    void print_matrix() const;
    void print_puzzle() const;

public:
    static void copy_matrix(const matrix_t* src, matrix_t* dst)
    {
        std::memcpy(dst, src, sizeof(matrix_t));
    }

    static void print(const matrix_t& matrix);

private:
    static bool check_value(const matrix_t& board, size_t pos, char val);

public:
    class Solver
    {
    public:
        Solver(const matrix_t& p);
        void solve();

    public:
        using solution_t = std::vector<char>;
        using solutions_t = std::vector<solution_t>;

    public:
        const std::vector<solution_t>& get_solutions();
        void get_result_matrix(matrix_t& m, const solution_t& s);

    private:
        using blank_positions_t = std::vector<size_t>;
        using values_to_check_t = std::vector<std::set<char>>;

    private:
        void init();
        void process_position(matrix_t& board, size_t index);

    private:
        const matrix_t& puzzle;
        blank_positions_t blank_positions;
        values_to_check_t values_to_check;
        solutions_t solutions;
    };

    class Checker
    {
    public:
        Checker(const matrix_t& p);
        bool check();

    private:
        using blank_positions_t = std::vector<size_t>;
        using values_to_check_t = std::vector<std::set<char>>;

    private:
        void init();
        bool process_position(matrix_t& board, size_t index, bool& found);

    private:
        const matrix_t& puzzle;
        blank_positions_t blank_positions;
        values_to_check_t values_to_check;
    };

private:
    class Matrix_Generator
    {
    public:
        Matrix_Generator(matrix_t& m);
        void generate();

    private:
        enum Result
        {
            NEXT,
            FAIL,
            STOP
        };

        class Number
        {
        public:
            Number(char n);
            bool set_at_position(size_t pos);
            bool exclude_possible_position(size_t pos);
            size_t pick_compulsory_position();
            size_t pick_possible_position();
            bool update_positions(const matrix_t& matrix);
            bool is_possible_position();
            bool is_compulsory_position();
            void add_checked_positions(size_t pos);
            void set_checked_positions(std::set<size_t>& positions);
            std::set<size_t>& get_checked_positions();
            bool exclude_checked_positions();

            bool operator == (const Number& other) const;
            operator char () const;

        public:
            void print_possible_positions();
            void print_possible_positions(const matrix_t& matrix);

        private:
            void init_possible_positions();
            void update_compulsory_positions();

        private:
            std::set<size_t> possible_positions;    // may be picked
            std::set<size_t> compulsory_positions;  // mast be selected
            std::set<size_t> occupied_positions;    // auxiliary for nice printing
            std::set<size_t> checked_positions;     // checked positions for current stage (that were picked but it causes fail), shall be removed from the possible
            const char num;
            unsigned char count;
        };

        struct Stage
        {
            Stage (const matrix_t& m, size_t i, std::set<size_t>& positions) : number_index(i)
            {
                copy_matrix(&m, &matrix);
                checked_positions.swap(positions);
            }

            matrix_t matrix;
            size_t number_index;
            std::set<size_t> checked_positions; // positions that were examined at the current stage
        };

    private:
        void init_blank_matrix();
        bool update_positions();
        void store_stage(size_t i);
        bool restore_stage(size_t& i);
        Result update_others(size_t i, size_t pos);
        Result process_compulsory();
        Result process_possible(size_t i);
        bool fill();
        bool produce();

    private:
        /* Optional inital magic to make generation faster */
        void generate_initial_blocks();
        void generate_initial();

    private:
        /* Paranoid check */
        bool check_consistency();

    private:
        matrix_t& matrix;
        Number numbers[9] = {'1', '2', '3', '4', '5', '6', '7', '8', '9'};
        std::vector<Stage> stages;
    };

    class Puzzle_Creator
    {
    public:
        Puzzle_Creator(const matrix_t& m, matrix_t& p);
        void create();

        void select_easy();
        void select_medium();
        void select_hard();
        void select_expert();

    private:
        struct Position_Info
        {
            std::set<char> possible_values;
            std::set<size_t> affected_positions;
        };

        using suite_t = std::vector<std::set<size_t>>;

    private:
        void init_positions();
        void update_possible_values(size_t pos);
        void update_affected_values(size_t pos);
        bool hide_position(size_t pos);
        std::set<size_t> get_positions_to_hide();

        template<typename I>
        void select_set(const I it);

    private:
        const matrix_t& matrix;
        matrix_t& puzzle;
        std::map<size_t, Position_Info> positions;
        std::set<size_t> current_hidden_positions;
        suite_t hidden_positions_suite;
        Checker checker;
    };

private:
    Matrix_Generator generator;
    Puzzle_Creator creator;

    matrix_t matrix;
    matrix_t puzzle;
};

#endif // SUDOKU_H
