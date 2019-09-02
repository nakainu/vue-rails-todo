<template>
<div>
  <p v-for="{ name } in lists">{{ name }}</p>
  <!-- 新規作成部分 -->
  <div class="row">
    <div class="col s10 m11">
      <span>ToDo名</span>
      <input v-model="newTodo" class="form-control" placeholder="ToDo名を入力してください">
      <span>期限</span>
      <input v-model="newDate" type="date">
    </div>
    <div class="col s2 m1">
      <div v-on:click="createTodo" class="btn-floating waves-effect waves-light red">
        <i class="material-icons">add</i>
      </div>
    </div>
  </div>
  <p>{{ this.message }}</p>
  <!-- リスト表示部分 -->
  <div>
    <ul class="collection">
      <li v-for="todo in todos" v-if="!todo.is_done" v-bind:id="'row_todo_' + todo.id" class="collection-item">
        <label v-bind:for="'todo_' + todo.id">
            <input type="checkbox" v-on:change="doneTodo(todo.id)" v-bind:id="'todo_' + todo.id" />
            <span>{{ todo.name }}</span><br>
            <span>期限：{{ todo.deadline }}</span><br>
            <span>作成日：{{ todo.created_at }}</span>
          </label>
      </li>
    </ul>
  </div>
  <!-- 完了済みタスク表示ボタン -->
  <div class="btn" v-on:click="displayFinishedTodos">完了済み</div>
  <!-- 完了済みタスク一覧 -->
  <div id="finished-todos" class="display_none">
    <ul class="collection">
      <li v-for="todo in todos" v-if="todo.is_done" v-bind:id="'row_todo_' + todo.id" class="collection-item">
        <label v-bind:for="'todo_' + todo.id">
            <input v-on:change="yetTodo(todo.id)" type="checkbox" v-bind:id="'todo_' + todo.id" checked="checked" />
            <span class="line-through">{{ todo.name }}</span><br>
            <span class="line-through">期限：{{ todo.deadline }}</span><br>
            <span class="line-through">作成日：{{ todo.created_at }}</span><br>
          </label>
      </li>
    </ul>
  </div>

</div>
</template>

<script>
import axios from 'axios';
axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

export default {
  data: function() {
    return {
      id: '',
      lists: [],
      todos: [],
      newTodo: '',
      newDate: '',
      message: ''
    }
  },
  mounted: function() {
    this.fetchListTodo();
  },
  methods: {
    fetchListTodo: function() {
      var id = this.$route.params.id;
      this.id = id;
      axios.get('/api/lists').then((response) => {
        for (var i = 0; i < response.data.lists.length; i++) {
          this.lists.push(response.data.lists[i]);
          this.lists = this.lists.filter(function(object) {
            return object.id == id;
          });
        }
      }, (error) => {
        console.log(error);
      });

      axios.get('/api/todos').then((response) => {
        for (var i = 0; i < response.data.todos.length; i++) {
          this.todos.push(response.data.todos[i]);
          this.todos = this.todos.filter(function(object) {
            return object.list_id == id;
          });
        }
      }, (error) => {
        console.log(error);
      });
    },
    createTodo: function() {
      var matchTodoName = this.todos.filter(x => x.name == this.newTodo);

      if (!this.newTodo) {
        return this.message = 'ToDoの名称は1文字以上入力してください';

      }
      else if(this.newTodo.length > 30) {
        return this.message = 'ToDoの名称は30文字以内にしてください';
      }
      else if(Object.keys(matchTodoName).length == 1){
        return this.message = '作成するToDo名はすでに存在します';
      }else{
        axios.post('/api/todos', {
          todo: {
            name: this.newTodo,
            deadline: this.newDate,
            list_id: this.id
          }
        }).then((response) => {
          this.todos.unshift(response.data.todo);
          this.newTodo = '';
          this.newDate = '';
          this.message = '新しいToDoが作成されました';
        }, (error) => {
          console.log(error);
        });
      }
    },
    displayFinishedTodos: function() {
      document.querySelector('#finished-todos').classList.toggle('display_none');
    },
    doneTodo: function(todo_id) {
      axios.put('/api/todos/' + todo_id, {
        todo: {
          is_done: 1
        }
      }).then((response) => {
        // this.moveFinishedTodo(todo_id);

        for (var i = 0; i < this.todos.length; i++) {
          if(this.todos[i].id == todo_id){
            this.todos[i].is_done = true;
          }
        }

      }, (error) => {
        console.log(error);
      });
    },
    yetTodo: function(todo_id) {
      axios.put('/api/todos/' + todo_id, {
        todo: {
          is_done: 0
        }
      }).then((response) => {

        for (var i = 0; i < this.todos.length; i++) {
          if(this.todos[i].id == todo_id){
            this.todos[i].is_done = false;
          }
        }

      }, (error) => {
        console.log(error);
      });
    },
  },
  watch: {
  }
}
</script>

<style>
[v-cloak] {
  display: none;
}

.display_none {
  display: none;
} // 打ち消し線を引く
.line-through {
  text-decoration: line-through;
}
</style>
