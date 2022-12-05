#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "stack.h"

char *read_row(FILE* file);
char **read_stack_rows(FILE* file, int *row_count);
struct Stack construct_stack(char **rows, int count, int column);
struct Stack *construct_stacks(char **rows, int count, int *stack_count);
void interpret_commands(FILE *file, struct Stack *stacks);
void free_rows(char **rows, int row_count);

int main(int argc, char **argv) {
  char *file_name = argv[1];
  FILE *file = fopen(file_name, "r");
  int count = 0;
  int scount = 0;

  char **rows = read_stack_rows(file, &count);
  struct Stack *stacks = construct_stacks(rows, count, &scount);
  interpret_commands(file, stacks);

  for (int i = 0; i < scount; i++) {
    printf("%c", spop(stacks + i));
    sfree(stacks[i]);
  }

  free(stacks);
  free_rows(rows, count);
  fclose(file);

  return 0;
}


void free_rows(char **rows, int row_count) {
  for (int i = 0; i < row_count; i++) {
    free(rows[i]);
  }

  free(rows);
}

int next_int(FILE *file) {
  char temp = 'x';
  while (!isdigit(temp) && !feof(file)) {
    fread(&temp, sizeof temp, 1, file);
  }

  char *num_str = malloc(0);
  int str_len = 0;
  while (isdigit(temp)) {
    num_str = realloc(num_str, sizeof *num_str * (str_len + 1));
    num_str[str_len] = temp;
    fread(&temp, sizeof temp, 1, file);
    str_len++;
  }

  int result = atoi(num_str);

  free(num_str);

  return result;
}

void move_from_to(struct Stack *stacks, int move, int from, int to) {
  for (int i = 0; i < move; i++) {
    char popped = spop(stacks + from - 1);
    spush(stacks + to - 1, popped);
  }
}

void interpret_command(FILE *file, struct Stack *stacks) {
  int move = next_int(file);
  if (feof(file))
    return;
  int from = next_int(file);
  int to = next_int(file);

  move_from_to(stacks, move, from, to);
}

void interpret_commands(FILE *file, struct Stack *stacks) {
  while (!feof(file)) {
    interpret_command(file, stacks);
  }
  return;
}

char *read_row(FILE* file) {
  char *buf = malloc(0);
  char read_char;
  int i = 0;

  fread(&read_char, sizeof read_char, 1, file);

  while (read_char != '\n') {
    buf = realloc(buf, sizeof *buf * (i + 1));
    buf[i] = read_char;
    i++;
    fread(&read_char, sizeof read_char, 1, file);
  }

  buf = realloc(buf, sizeof *buf * (i + 1));
  buf[i] = '\0';

  return buf;
}

char **read_stack_rows(FILE* file, int *row_count) {
  char **rows = malloc(0);
  char *row;
  int i = 0;

  for (char *row = read_row(file); strlen(row) != 0; row = read_row(file)) {
    rows = realloc(rows, sizeof *rows * (i + 1));
    rows[i] = row;
    i++;
  }

  *row_count = i;

  return rows;
}

struct Stack construct_stack(char **rows, int count, int column) {
  int index = rows[count-1][column] - '0';
  struct Stack stack = sinit(index);

  for (int i = count - 2; i >= 0; i--)
    if(rows[i][column] != ' ')
      spush(&stack, rows[i][column]);

  return stack;
}

struct Stack *construct_stacks(char **rows, int count, int *stack_count) {
  struct Stack *stacks = malloc(0);
  int stack_amount = 0;
  char *indexes = rows[count - 1];
  int n = strlen(indexes);
  for (int i = 0; i < strlen(indexes); i++)
    if (indexes[i] != ' ') {
      stacks = realloc(stacks, sizeof *stacks * (stack_amount + 1));
      stacks[stack_amount] = construct_stack(rows, count, i);
      stack_amount++;
    }

  *stack_count = stack_amount;

  return stacks;
}
