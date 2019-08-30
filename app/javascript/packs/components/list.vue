<template>
  <div>
    <p v-for="{ name } in lists">{{ name }}</p>
    <!-- 新規作成部分 -->
    <div class="row">
      <div class="col s10 m11">
        <input v-model="newTodo" class="form-control" placeholder="ToDo名">
      </div>
      <div class="col s2 m1">
        <div v-on:click="createTodo" class="btn-floating waves-effect waves-light red">
          <i class="material-icons">add</i>
        </div>
      </div>
    </div>
    <!-- リスト表示部分 -->
    <div>
      <ul class="collection">
        <li v-for="todo in todos" v-if="!todo.is_done" v-bind:id="'row_todo_' + todo.id" class="collection-item">
          <label v-bind:for="'todo_' + todo.id">
            <input type="checkbox" v-on:change="doneTodo(todo.id)" v-bind:id="'todo_' + todo.id" />
            <span>{{ todo.name }}</span>
          </label>
        </li>
      </ul>
    </div>
    <!-- 完了済みタスク表示ボタン -->
    <div class="btn" v-on:click="displayFinishedTodos">完了済み</div>
    <!-- 完了済みタスク一覧 -->
    <div id="finished-todos" class="display_none">
      <ul class="collection">
        <li v-for="todo in todos" v-if="todo.is_done"v-bind:id="'row_todo_' + todo.id" class="collection-item">
          <label v-bind:for="'todo_' + todo.id">
            <input input type="checkbox" v-bind:id="'todo_' + todo.id" checked="checked" />
            <span class="line-through">{{ todo.name }}</span>
          </label>
        </li>
      </ul>
    </div>

  </div>
</template>

<script>
  import axios from 'axios';
  axios.defaults.headers.common = { 'X-Requested-With': 'XMLHttpRequest',
   'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  };

  export default {
    data: function () {
      return {
        id: '',
        lists: [],
        todos:[],
        newTodo: ''
      }
    },
    mounted: function () {
      this.fetchListTodo();
    },
    methods: {
      fetchListTodo: function () {
        var id = this.$route.params.id;
        this.id = id;
        axios.get('/api/lists').then((response) => {
          for(var i = 0; i < response.data.lists.length; i++) {
            this.lists.push(response.data.lists[i]);
            this.lists = this.lists.filter(function(object) {
              return object.id == id;
            });
          }
        }, (error) => {
          console.log(error);
        });

        axios.get('/api/todos').then((response) => {
          for(var i = 0; i < response.data.todos.length; i++) {
            this.todos.push(response.data.todos[i]);
            this.todos = this.todos.filter(function(object) {
              return object.list_id == id;
            });
          }
        }, (error) => {
          console.log(error);
        });
      },
      createTodo: function () {
        if (!this.newTodo) return;

        axios.post('/api/todos', { todo: { name: this.newTodo, list_id: this.id } }).then((response) => {
          this.todos.unshift(response.data.todo);
          this.newTodo = '';
        }, (error) => {
          console.log(error);
        });
      },
      displayFinishedTodos: function() {
        document.querySelector('#finished-todos').classList.toggle('display_none');
      },
      doneTodo: function (todo_id) {
        axios.put('/api/todos/' + todo_id, { todo: { is_done: 1 } }).then((response) => {
          this.moveFinishedTodo(todo_id);
        }, (error) => {
          console.log(error);
        });
      },
      moveFinishedTodo: function(todo_id) {
        var el = document.querySelector('#row_todo_' + todo_id);
        // DOMをクローン
        var el_clone = el.cloneNode(true);
        // 未完了の方を先に非表示
        el.classList.add('display_none');
        // 完了済みに追加
        el_clone.getElementsByTagName('input')[0].checked = 'checked';
        el_clone.getElementsByTagName('span')[0].classList.add('line-through');
        el_clone.getElementsByTagName('span')[0].classList.remove('word-color-black');
        var li = document.querySelector('#finished-todos > ul > li:first-child');
        document.querySelector('#finished-todos > ul').insertBefore(el_clone, li);
      },

    }
  }
</script>

<style>
  [v-cloak] {
    display: none;
  }
  .display_none {
    display:none;
  }
  // 打ち消し線を引く
  .line-through {
    text-decoration: line-through;
  }
</style>
