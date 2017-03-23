/*                 UQAM ON STRIKE PUBLIC LICENSE
 *                    Version 2, December 2004
 *
 * Copyright (C) 2017
 * Alexandre Terrasa <@>,
 * Jean Privat <@>,
 * Philippe Pepos Petitclerc <@>
 *
 * Everyone is permitted to copy and distribute verbatim or modified
 * copies of this license document, and changing it is allowed as long
 * as the name is changed.
 *
 *                 UQAM ON STRIKE PUBLIC LICENSE
 *   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 *
 *  0. You just do what the fuck you want to as long as you're on strike.
 *
 * aHR0cDovL2NzZ2FtZXMub3JnLzIwMTYvCg==
 */

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* Min-heap data structure. Basically by the book. */

struct node {
	double priority;
	void *data;
};

struct heap {
	struct node *nodes;
	int len;
	int size;
	int (*compare)(const void *data1, const void *data2);
};

void enqueue(struct heap *heap, double priority, void *data) {
	if (heap->size <= heap->len + 1) {
		int size = heap->size * 2;
		if (size < 4) // not enough space :\
			size = 4;
		heap->size = size;
		heap->nodes = (struct node *)realloc(heap->nodes, heap->size * sizeof (struct node));
	}

	int i = heap->len++;
	while(i>0) {
		int p = (i+1)/2-1;
		if (heap->nodes[p].priority < priority)
			break;
		if (heap->nodes[p].priority == priority && heap->compare(heap->nodes[p].data, data) <= 0)
			break;
		heap->nodes[i] = heap->nodes[p];
		i = p;
	}
	heap->nodes[i].priority = priority;
	heap->nodes[i].data = data;
	//printf("enqueue %p at %d, cost=%f\n", data, i, priority);
}

struct state *dequeue(struct heap *heap) {
	if (heap->len==0)
		return NULL;
	void *result = heap->nodes[0].data;
	//printf("dequeue %p cost=%f\n", result, heap->nodes[0].priority);

	int i = 0;
	heap->nodes[i] = heap->nodes[--heap->len];
	for(;;) {
		int l = 2*(i+1) - 1;
		int r = l+1;
		int c = i;
		if (l < heap->len && heap->nodes[l].priority < heap->nodes[c].priority)
			c = l;
		if (l < heap->len && heap->nodes[l].priority == heap->nodes[c].priority && heap->compare(heap->nodes[l].data, heap->nodes[c].data) < 0)
			c = l;
		if (r < heap->len && heap->nodes[r].priority < heap->nodes[c].priority)
			c = r;
		if (r < heap->len && heap->nodes[r].priority == heap->nodes[c].priority && heap->compare(heap->nodes[r].data, heap->nodes[c].data) < 0)
			c = l;
		if (c == i)
			break;
		struct node tmp = heap->nodes[i];
		heap->nodes[i] = heap->nodes[c];
		heap->nodes[i] = tmp;
		i = c;
	}

	return result;
}

struct heap* new_heap(void) {
	return (struct heap*)calloc(sizeof(struct heap),1);
}

// Empty the heap and deallocate the data first please.
void free_heap(struct heap* heap) {
	free(heap->nodes);
	free(heap);
}

/* Simple A* search */

struct state {
	struct state *prev;
	int money;
	int fun;
	int time;
	const char *desc;
};

/* Ensure a total preference on a state.
 * so for the same (if the used see variable result for the same input, he will assume the program is buggy... users are dumb) */
int state_compare(const struct state *s1, const struct state *s2) {
	if (s1->time < s2->time) return -1;
	if (s1->time > s2->time) return 1;
	if (s1->money > s2->money) return -1;
	if (s1->money < s2->money) return 1;
	if (s1->fun > s2->fun) return -1;
	if (s1->fun < s2->fun) return 1;
	if (s1->prev == NULL && s2->prev == NULL) return 0;
	if (s1->prev == NULL) return -1;
	if (s2->prev == NULL) return 1;
	return state_compare(s1->prev, s2->prev);
}

/* Global data */
struct problem {
	/* initial state */
	struct state *start;
	/* goals */
	int money_goal;
	int fun_goal;
	/* memorize states per position. */
	struct state *area[200][200];
	/* the associated priority queue. */
	struct heap *heap;
};

/* If possible, create and register the new state for the move (`dmoney`,`dfun`) from the state `state`. */
struct state *next_state(struct state *state, struct problem *problem, int dmoney, int dfun, const char *desc) {
	if (state->money + dmoney < 0 || state->fun + dfun < 0)
		return NULL;

	dmoney += state->money;
	if (dmoney > 200) dmoney = 200;
	dfun += state->fun;
	if (dfun > 200) dfun = 200;
	int time = state->time + 1;

	struct state *result = (struct state*)malloc(sizeof(struct state));
	result->prev = state;
	result->money = dmoney;
	result->fun = dfun;
	result->time = time;
	result->desc = desc;

	if (dmoney < 200 && dfun < 200) {
		struct state * old = problem->area[dmoney][dfun];
		if (old != NULL && state_compare(old, result) <= 0) {
			free(result);
			return NULL;
		}
	}

	/* Heuristic: Chebyshev distance with the max known moves. */
	double cost = result->time;
	double cm = result->money < problem->money_goal ? (problem->money_goal - result->money) / 34.0 : 0.0;
	double cf = result->fun < problem->fun_goal ? (problem->fun_goal - result->fun) / 34.0 : 0.0;
	cost += cm > cf ? cm : cf;

	//printf("in t=%d %s m=%d f=%d h=%f c=%f\n", result->time, result->desc, result->money, result->fun, cost-result->time, cost);
	if (dmoney < 200 && dfun < 200) {
		problem->area[dmoney][dfun] = result;
	}
	enqueue(problem->heap, cost, result);

	return result;
}

struct state * solve(int money_start, int fun_start, int money_goal, int fun_goal) {
	struct problem *problem = (struct problem*)malloc(sizeof(struct problem));
	struct state *state = (struct state*)malloc(sizeof(struct state));
	state->prev = NULL;
	state->money = money_start;
	state->fun = fun_start;
	state->time = 0;
	problem->start = state;
	struct heap *heap = new_heap();
	heap->compare = (int(*)(const void*,const void*))&state_compare;
	problem->heap = heap;
	problem->money_goal = money_goal;
	problem->fun_goal = fun_goal;

	enqueue(heap, 0, state);
	int i = 0;
	while((state=dequeue(heap))) {
		i++;
		//if (i%1 == 0) printf("%d out t=%d %s m=%d f=%d\n", i, state->time, state->desc, state->money, state->fun);

		if (state->money >= money_goal && state->fun >= fun_goal) return state;

		next_state(state, problem,   0, +1, "tv"); // watch tv and chill

		switch(state->time % 3) {
			// night, 1:00 -> 9:00
			case 0: next_state(state, problem, -24, +34, "night fiesta"); // booze is expensive, but you have the rest of the night to vomit
				next_state(state, problem, +8,   0, "early work"); // early work is calm but don't pay that much
				break;
			// day, 9:00 -> 15:00
			case 1: next_state(state, problem, -4,  +14, "home alcoholism"); // at home, nobody can judge you
				next_state(state, problem, +28, -28, "day work"); // day work with people, you hate people
				break;
			// evening, 15:00 -> 1:00
			case 2:
				next_state(state, problem, -14, +24, "night pub"); // nice booze and nice people to hang out with
				next_state(state, problem, +18,  -8, "night work"); // night work is boring
				break;
		}
	}
	return NULL;
}

void dump_heap(struct heap *heap) {
	for(int i=0; i<heap->len; i++) {
		int j = i;
		printf("n[%d]=%f %p", j, heap->nodes[j].priority, heap->nodes[j].data);
		while (j>0) {
			j = (j+1)/2-1;
			printf(" > n[%d]=%f", j, heap->nodes[j].priority);
		}
		printf("\n");
	}
}

int test_heap(void) {
	struct heap *heap = new_heap();
	heap->compare = (int(*)(const void*, const void*))&strcmp;
	for(int i = 0; i<50; i++) {
		char s[100];
		int x = rand() % 500;
		sprintf(s, "%d", x);
		enqueue(heap, x, strdup(s));
		//printf("n[0]=%f %p\n", heap->nodes[0].priority, heap->nodes[0].data);
	}
	dequeue(heap);

	char *s;
	while((s=(char*)dequeue(heap))) {
		printf("* %s\n", s);
	}
}

const char *days[] = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
const char *hours[] = {"1:00 -> 9:00", "9:00 -> 15:00", "15:00 -> 1:00"};

void print_plan(struct state *state) {
	if (state == NULL) return;
	print_plan(state->prev);
	int t = state->time - 1;
	if (t < 0)
		printf("* initial money=%d fun=%d\n", state->money, state->fun);
	else
		printf("* %s %s: %s (money=%d fun=%d)\n", days[t/3%7], hours[t%3], state->desc, state->money, state->fun);
}

int main(int argc, char **argv) {
	//test_heap(); exit(0);

	struct state *state = solve(argc>1?atoi(argv[1]):10, argc>2?atoi(argv[2]):10, argc>3?atoi(argv[3]):100, argc>4?atoi(argv[4]):100);
	if (state != NULL)
		print_plan(state);
	else
		printf("No solution\n");
}
