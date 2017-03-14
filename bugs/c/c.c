#include <stdlib.h>
#include <string.h>
#include <stdio.h>


struct node {
	double priority;
	void *data;
};

struct heap {
	struct node *nodes;
	int len;
	int size;
};

void enqueue(struct heap *heap, double priority, void *data) {
	if (heap->size <= heap->len + 1) {
		int size = heap->size * 2;
		if (size < 4) // not enough space :\ BUG
			size = 4;
		heap->size = size;
		heap->nodes = (struct node *)realloc(heap->nodes, heap->size * sizeof (struct node));
	}

	int i = heap->len++;
	while(i>0) {
		int p = (i+1)/2-1;
		if (heap->nodes[p].priority <= priority)
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
		if (r < heap->len && heap->nodes[r].priority < heap->nodes[c].priority)
			c = r;
		if (c == i)
			break;
		struct node tmp = heap->nodes[i];
		heap->nodes[i] = heap->nodes[c];
		heap->nodes[c] = tmp; // BUG chier le swap
		i = c;
	}

	return result;
}

struct heap* new_heap(void) {
	return (struct heap*)calloc(sizeof(struct heap),1);
}

void free_heap(struct heap* heap) {
	free(heap->nodes);
	free(heap);
}

struct state {
	struct state *prev;
	int money;
	int fun;
	int time;
	const char *desc;
};

struct state *area[110][110];

struct state *next_state(struct state *state, struct heap *heap, int dmoney, int dfun, const char *desc) {
	if (state->money + dmoney < 0 || state->fun + dfun < 0)
		return NULL;

	dmoney += state->money;
	if (dmoney > 200) dmoney = 200;
	dfun += state->fun;
	if (dfun > 200) dfun = 200;
	int time = state->time + 1;

	if (dmoney < 110 && dfun < 110) {
		struct state * old = area[dmoney][dfun];
		if (old != NULL && old->time >= time) {
			return NULL;
		}
	}

	struct state *result = (struct state*)malloc(sizeof(struct state));
	result->prev = state;
	result->money = dmoney;
	result->fun = dfun;
	result->time = time;
	result->desc = desc;

	double cost = result->time;
	double cm = result->money < 100 ? (100.0 - result->money) / 34 : 0;
	double cf = result->fun < 100   ? (100.0 - result->fun) / 34 : 0;
	cost += cm > cf ? cm : cf;
	//cost += cm + cf;

	//printf("in t=%d %s m=%d f=%d h=%f c=%f\n", result->time, result->desc, result->money, result->fun, cost-result->time, cost);
	if (dmoney < 110 && dfun < 110) {
		area[dmoney][dfun] = result;
	}
	enqueue(heap, cost, result);

	return result;
}

void solve(void) {
	struct state *state = (struct state*)malloc(sizeof(struct state));
	state->prev = NULL;
	state->money = 0;
	state->fun = 10;
	state->time = 10;
	struct heap *heap = new_heap();

	enqueue(heap, 0, state);
	printf("hello\n");

	int i = 0;
	while((state=dequeue(heap))) {
		i++;
		if (i%1000 == 0)
		printf("%d out t=%d %s m=%d f=%d\n", i, state->time, state->desc, state->money, state->fun);

		if (state->money >= 100 && state->fun >= 100) {
			while (state) {
				printf("t=%d %s m=%d f=%d\n", state->time, state->desc, state->money, state->fun);
				state = state->prev;
			}
			return;
		}

		//next_state(state, heap,   0, 0, "tv"); // watch tv and chill
		//next_state(state, heap,   0, 20, "0,20"); // watch tv and chill
		//next_state(state, heap,   10, 10, "10,10"); // watch tv and chill
		//next_state(state, heap,   20, 0, "20,0"); // watch tv and chill
		//next_state(state, heap,   20, 10, "20,10"); // watch tv and chill
		next_state(state, heap,   20, -10, "20,-10"); // watch tv and chill
		next_state(state, heap,   -20, 10, "-20,10"); // watch tv and chill
		next_state(state, heap,   -20, -10, "-20,-10"); // watch tv and chill
		//next_state(state, heap,   10, 20, "10,20"); // watch tv and chill
		next_state(state, heap,   -10, 20, "-10,20"); // watch tv and chill
		next_state(state, heap,   10, -20, "10,-20"); // watch tv and chill
		next_state(state, heap,   -10, -20, "-10,-20"); // watch tv and chill
		//next_state(state, heap,   -1, +10, "tv"); // watch tv and chill
		//next_state(state, heap,   10, -1, "mny"); // watch tv and chill
		//next_state(state, heap, -11, +21, "home booze"); // home booze
		//next_state(state, heap, +12, -12, "home work"); // home work
		continue;

		switch(state->time % 3) {
			// night, 1:00 -> 9:00
			case 0: next_state(state, heap, -24, +34, "night fiesta"); // booze is expensive, but you have the rest of the night to vomit
				next_state(state, heap, +8,   0, "early work"); // night work is boring but don't pay that much
				break;
			// day, 9:00 -> 15:00
			case 1: next_state(state, heap, -14, +24, "day pub"); // booze
				next_state(state, heap, +28, -28, "day work"); // day work with people
				break;
			// evening, 15:00 -> 1:00
			case 2:
				next_state(state, heap, -24, +34, "night pub"); // booze
				next_state(state, heap, +18,  -8, "night work"); // work
				break;
		}
	}
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
	for(int i = 0; i<50; i++) {
		char s[100];
		int x = rand() % 50;
		sprintf(s, "%d", x);
		enqueue(heap, x, strdup(s));
		printf("n[0]=%f %p\n", heap->nodes[0].priority, heap->nodes[0].data);
	}
	dequeue(heap);

	char *s;
	while((s=dequeue(heap))) {
		printf("* %s\n", s);
	}
}

int main(void) {
	//test_heap();
	solve();
}
