#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "stack.h"

void sprint(struct Stack stack) {
  struct Node *head = stack.head;

  while (head != NULL) {
    printf("%c", head->value);
    head = head->next;
  }

  printf("\n");

  return;
}

char spop(struct Stack *stack) {
  char popped = stack->head->value;
  struct Node *temp = stack->head;
  stack->head = temp->next;
  free(temp);
  return popped;
}

void spush(struct Stack *stack, char c) {
  struct Node *node = malloc(sizeof *node);
  node->value = c;
  node->next = stack->head;
  stack->head = node;
  return;
}

void sfree(struct Stack stack) {
  struct Node *head = stack.head;
  struct Node *temp;

  while (head != NULL) {
    temp = head->next;
    free(head);
    head = temp;
  }
}

struct Stack sinit(int index) {
  struct Stack stack;
  stack.head = NULL;
  return stack;
}
