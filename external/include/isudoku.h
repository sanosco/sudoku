#ifndef ISUDOKU_H
#define ISUDOKU_H

#include <memory>

struct I_Sudoku
{
    using matrix_t = char[9][9];

    static constexpr size_t pos_num =  9 * 9;
    static constexpr char blank = '*';

    virtual ~I_Sudoku() = default;

    virtual void make_matrix() = 0;
    virtual void make_puzzle() = 0;

    virtual void select_easy() = 0;
    virtual void select_medium() = 0;
    virtual void select_hard() = 0;
    virtual void select_expert() = 0;

    virtual const matrix_t& get_matrix() const = 0;
    virtual const matrix_t& get_puzzle() const = 0;
};

using sudoku_ptr_t = std::unique_ptr<I_Sudoku>;

sudoku_ptr_t createSudoku();

#endif // ISUDOKU_H
