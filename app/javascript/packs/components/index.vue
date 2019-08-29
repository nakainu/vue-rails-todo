<template>
  <div>
    <!-- 新規作成部分 -->
    <div class="row">
      <div class="col s10 m11">
        <input v-model="newList" class="form-control" placeholder="Add List">
      </div>
      <div class="col s2 m1">
        <div v-on:click="createList" class="btn-floating waves-effect waves-light red">
          <i class="material-icons">add</i>
        </div>
      </div>
    </div>
    <!-- リスト表示部分 -->
    <div>
      <ul class="collection">
        <li v-for="list in lists" v-bind:id="'row_list_' + list.id" class="collection-item">
          <label>
            <span v-bind:for="'list_' + list.id">{{ list.name }}</span><br>
            <span>x個中x個がチュエック済み</span><br>
            <span>~yyyy年mm月dd日</span>
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
        lists: [],
        newList: ''
      }
    },
    mounted: function () {
      this.fetchLists();
    },
    methods: {
      fetchLists: function () {
        axios.get('/api/lists').then((response) => {
          for(var i = 0; i < response.data.lists.length; i++) {
            this.lists.push(response.data.lists[i]);
          }
        }, (error) => {
          console.log(error);
        });
      },
      createList: function () {
        if (!this.newList) return;

        axios.post('/api/lists', { list: { name: this.newList } }).then((response) => {
          this.lists.unshift(response.data.list);
          this.newList = '';
        }, (error) => {
          console.log(error);
        });
      }
    }
  }
  </script>
