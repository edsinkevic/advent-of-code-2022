#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "stack.h"

struct Command {
  int move;
  int from;
  int to;
};

char *read_row(FILE* file);
char **read_stack_rows(FILE* file, int *row_count);
struct Stack construct_stack(char **rows, int count, int column);
struct Stack *construct_stacks(char **rows, int count, int *stack_count);
void interpret_commands(FILE *file, struct Stack *stacks, void (*command_handler)(struct Stack *stacks, struct Command command));
void free_rows(char **rows, int row_count);
void move_from_to2(struct Stack *stacks, struct Command command);
void move_from_to1(struct Stack *stacks, struct Command command);
void solve(char *file_name, void (*command_handler)(struct Stack *stacks, struct Command command));


int main(int argc, char **argv) {
  char *file_name = argv[1];
  solve(file_name, &move_from_to1);
  solve(file_name, &move_from_to2);

  return 0;
}

void solve(char *file_name, void (*command_handler)(struct Stack *stacks, struct Command command)) {
  FILE *file = fopen(file_name, "r");
  int count = 0;
  int scount = 0;

  char **rows = read_stack_rows(file, &count);
  struct Stack *stacks = construct_stacks(rows, count, &scount);
  interpret_commands(file, stacks, command_handler);

  for (int i = 0; i < scount; i++) {
    printf("%c", spop(stacks + i));
    sfree(stacks[i]);
  }

  printf("\n");

  free(stacks);
  free_rows(rows, count);
  fclose(file);
}


void free_rows(char **rows, int row_count) {
  for (int i = 0; i < row_count; i++) {
    free(rows[i]);
  }

  free(rows);
}

void move_from_to1(struct Stack *stacks, struct Command command) {
  struct Stack *from_ptr = stacks + command.from;
  struct Stack *to_ptr = stacks + command.to;

  for (int i = 0; i < command.move; i++) {
    char popped = spop(from_ptr);
    spush(to_ptr, popped);
  }
}

void move_from_to2(struct Stack *stacks, struct Command command) {
  struct Stack temp_stack = sinit();
  struct Stack *from_ptr = stacks + command.from;
  struct Stack *to_ptr = stacks + command.to;

  for (int i = 0; i < command.move; i++) {
    char popped = spop(from_ptr);
    spush(&temp_stack, popped);
  }

  for (int i = 0; i < command.move; i++) {
    char popped = spop(&temp_stack);
    spush(to_ptr, popped);
  }
}

char *skip_digits(char *str) {
  int i = 0;
  while (isdigit(str[i])) {
    i++;
  }
  return str + i;
}

char *skip_non_digits(char *str) {
  int i = 0;
  while (!isdigit(str[i])) {
    i++;
  }
  return str + i;
}

char *skip_till_next_digit(char *str) {
  return skip_non_digits(skip_digits(str));
}

struct Command parse_command(char *str) {
  struct Command command;
  int i = 0;
  str = skip_non_digits(str);
  command.move = atoi(str);
  str = skip_till_next_digit(str);
  command.from = atoi(str) - 1;
  str = skip_till_next_digit(str);
  command.to = atoi(str) - 1;

  return command;
}

void interpret_command(char *command_str, struct Stack *stacks, void (*command_handler)(struct Stack *stacks, struct Command command)) {
  struct Command command = parse_command(command_str);
  (*command_handler)(stacks, command);
}

void interpret_commands(FILE *file, struct Stack *stacks, void (*command_handler)(struct Stack *stacks, struct Command command)) {
  char *command_row = read_row(file);
  while (strlen(command_row) != 0) {
    interpret_command(command_row, stacks, command_handler);
    free(command_row);
    command_row = read_row(file);
  }
}

char *read_row(FILE* file) {
  char *row_buffer = malloc(0);
  char read_char;
  int row_length = 0;

  fread(&read_char, sizeof read_char, 1, file);

  for (int i = 0; read_char != '\n' && !feof(file); i++) {
    row_length = i + 1;
    row_buffer = realloc(row_buffer, sizeof *row_buffer * row_length);
    row_buffer[i] = read_char;
    fread(&read_char, sizeof read_char, 1, file);
  }
  row_buffer[row_length] = '\0';

  return row_buffer;
}

char **read_stack_rows(FILE* file, int *row_count) {
  char **rows = malloc(0);
  char *row;
  int row_length = 0;

  for (char *row = read_row(file); strlen(row) != 0; row = read_row(file)) {
    rows = realloc(rows, sizeof *rows * (row_length + 1));
    rows[row_length] = row;
    row_length++;
  }

  *row_count = row_length;

  return rows;
}

struct Stack construct_stack(char **rows, int count, int column) {
  struct Stack stack = sinit();
  for (int i = count - 2; i >= 0; i--)
    if(rows[i][column] != ' ')
      spush(&stack, rows[i][column]);

  return stack;
}

struct Stack *construct_stacks(char **rows, int count, int *stack_count) {
  struct Stack *stacks = malloc(0);
  int stack_amount = 0;
  char *indexes = rows[count - 1];
  int index_row_length = strlen(indexes);
  for (int i = 0; i < index_row_length; i++)
    if (indexes[i] != ' ') {
      stacks = realloc(stacks, sizeof *stacks * (stack_amount + 1));
      stacks[stack_amount] = construct_stack(rows, count, i);
      stack_amount++;
    }

  *stack_count = stack_amount;

  return stacks;
}
