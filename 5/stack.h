struct Node {
  char value;
  struct Node *next;
};

struct Stack {
  struct Node *head;
};
void sfree(struct Stack stack);
void sprint(struct Stack stack);
void spush(struct Stack *stack, char c);
char spop(struct Stack *stack);
struct Stack sinit(int index);
