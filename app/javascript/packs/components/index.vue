<template>
<div>
  <!-- 新規作成部分 -->
  <div class="row">
    <p>新しいToDoを作成する</p>

    <div class="col s10 m11">
      <input v-model="newList" class="form-control" placeholder="リスト名を入力してください">
    </div>
    <div class="col s2 m1">
      <div v-on:click="createList" class="btn-floating waves-effect waves-light red">
        <i class="material-icons">add</i>
      </div>
    </div>
  </div>
  <p>{{ this.message }}</p>

  <!-- リスト表示部分 -->
  <div>
    <template v-if="lists != null && todos != null">
      <ul class="collection">
        <li v-for="(list, index) in lists" v-bind:id="'row_list_' + list.id" class="collection-item">
          <label>
            <router-link :to="'/list/' + list.id"><span>{{ list.name }}</span></router-link><br>
            <template v-if="list.todos != undefined || list.todos != null">
              <template v-if="list.todos.length == 0">
                <span>ToDoがありません</span>
              </template>
              <template v-else>
                <span>{{ list.todos.length }}個中{{ getDoneNum(list.todos) }}個がチュエック済み</span><br>
                <span>~{{ getFirstDeadline(list.todos) }}</span>
              </template>
            </template>
            <template v-else>
              <span>ToDoがありません</span>
            </template>
          </label>
        </li>
      </ul>
    </template>

    <template v-else>
      <p>読込中</p>
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
        todos: [],
        newList: '',
        message: ''
      }
    },
    mounted: function () {
      this.fetchLists();
    },
    methods: {
      // ToDoリストの表示
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
      //リストの作成
      createList: function () {
        // リストの名前と新しいリストの名前が同じか否か
        var matchListName = this.lists.filter(x => x.name == this.newList);

        if(!this.newList){
          return this.message = 'ToDoリストの名称は1文字以上入力してください';

        }
        else if(this.newList.length > 30){
          return this.message = 'ToDoリストの名称は30文字以内にしてください';

        }
        else if(Object.keys(matchListName).length == 1){
          return this.message = '作成するToDoリスト名はすでに存在します';

        }else{
          axios.post('/api/lists', { list: { name: this.newList } }).then((response) => {
            this.lists.unshift(response.data.list);
            this.newList = '';
            this.message = '新しいToDoリストが作成されました';
          }, (error) => {
            console.log(error);
          });
        }
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
      // trueの数を数える関数
      getDoneNum: function (list) {
        var count = 0;
        //受け取ったリストの中の分だけループしてis_doneの数を返す
        for (var i = 0; i < list.length; i++) {
          if(list[i].is_done){
            count++;
          }
        }
        return count;
      },
      // リストの中のToDoで最も期限が早いものを返す
      getFirstDeadline: function(list) {
        var list = list.filter( function( value ) {
          return value.is_done == false;
        });
        if(list[0] === undefined){
          return '';
        }else{
          return list[0].deadline;
        }
      },
    }
  }
  </script>
