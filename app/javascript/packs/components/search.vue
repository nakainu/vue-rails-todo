<template>
  <div>
    <!-- 検索部分 -->
    <div class="row">
      <p>検索したいToDoを入力する</p>
      <div class="col s10 m10">
        <input v-model="searchTodos" class="form-control" placeholder="ToDoList or ToDo">
      </div>
      <div class="col s2 m2" v-on:click="searchList">
        <a class="waves-effect waves-light btn">検索</a>
      </div>
    </div>
    <!-- 検索ToDo部分 -->

    <div>
      <template v-if="fil_todos != null">
        <p>ToDoが{{ fil_todos.length }}件見つかりました</p>
      </template>
      <template v-if="fil_todos != null">
        <ul class="collection" v-for="todo in fil_todos">
          <li class="collection-item">
            <label>
              <router-link :to="'/list/' + routerListId(todo.list_id)"><span>{{ todo.name }}</span></router-link><br>
              <span>リスト名：{{ comparisonId(todo.list_id) }}</span><br>
              <span>期限：{{ todo.deadline }}</span><br>
              <span>作成日：{{ todo.created_at }}</span>
            </label>
          </li>
        </ul>
      </template>
    </div>
    <!-- 検索リスト一覧 -->
    <div>
      <template v-if="fil_lists != null">
        <p>ToDoリストが{{ fil_lists.length }}件見つかりました</p>
      </template>
      <template v-if="fil_lists != null">
        <ul class="collection" v-for="list in fil_lists">
          <li class="collection-item">
            <label>
              <router-link :to="'/list/' + list.id"><span>{{ list.name }}</span></router-link><br>
              <span>作成日：{{ list.created_at }}</span>
            </label>
          </li>
        </ul>
      </template>
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
      lists: [],
      fil_lists: null,
      todos: [],
      fil_todos: null,
      searchTodos: '',
    }
  },
  mounted: function () {
    this.fetchLists();
  },
  methods: {
    fetchLists: function () {
      // listsを取得
      axios.get('/api/lists').then((response) => {
        for(var i = 0; i < response.data.lists.length; i++) {
          this.lists.push(response.data.lists[i]);
        }
        // todosを取得
        axios.get('/api/todos').then((response) => {
          for(var i = 0; i < response.data.todos.length; i++) {
            this.todos.push(response.data.todos[i]);
          }

          this.concatenateArray();

        }, (error) => {
          console.log(error);
        });
      }, (error) => {
        console.log(error);
      });
    },
    // listsとtodosを結合する関数
    concatenateArray: function () {
      for(var i = 0; i < this.lists.length; i++) {
        this.lists[i]["todos"] = [];

        for(var j = 0; j < this.todos.length; j++) {
          if(this.lists[i].id == this.todos[j].list_id) {
            this.lists[i]["todos"].push(this.todos[j]);
          }
        }
      }
    },
    searchList: function () {
      var result_list = [];
      var result_todo = [];
      var word = this.searchTodos;

      // リストのフィルター
      result_list = this.lists.filter( function( value ) {
         return value.name.indexOf(word) > -1;
      });
      result_list.sort(function(a,b) {
        return (a.created_at < b.created_at ? 1 : -1);
      });
      this.fil_lists = result_list;

      // TODOのフィルター
      result_todo = this.todos.filter( function( value ) {
        return value.name.indexOf(word) > -1;
      });
      result_todo.sort(function(a,b) {
        return (a.created_at < b.created_at ? 1 : -1);
      });
      this.fil_todos = result_todo;

    },
    comparisonId: function (list_id) {
      var list = this.lists.filter( function( value ) {
        return value.id == list_id;
      });
      return list[0].name;
    },
    routerListId: function (list_id) {
      var list = this.lists.filter( function( value ) {
        return value.id == list_id;
      });
      return list[0].id;
    },

    getFirstDeadline: function(list){
      var list = list.filter( function( value ) {
        return value.is_done == false;
      });
      if(list[0] === undefined){
        return '';
      }else{
        return list[0].deadline;
      }
    }
  }
}
</script>
