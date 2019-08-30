<template>
  <div>
    <!-- 検索部分 -->
    <div class="row">
      <p>検索したいToDoを入力する</p>
      <div class="col s10 m10">
        <input class="form-control" placeholder="ToDoList or ToDo">
      </div>
      <div class="col s2 m2">
        <a class="waves-effect waves-light btn">検索</a>
      </div>
    </div>
    <!-- 検索ToDo部分 -->
    <div>
      <p>ToDoがxx件見つかりました</p>
      <ul class="collection">
        <li class="collection-item">
          <label>
            <span>sanmple todo</span><br>
            <span>リスト：レポート課題</span>
          </label>
        </li>
        <li class="collection-item">
          <label>
            <span>sanmple todo</span><br>
            <span>リスト：レポート課題</span>
          </label>
        </li>
      </ul>
    </div>
    <!-- 検索リスト一覧 -->
    <div>
      <p>ToDoリストがxx件見つかりました</p>
      <ul class="collection">
        <li class="collection-item">
          <label class="line-through">
            <span>リスト</span><br>
            <span>作成日：yyyy年mm月dd日</span>
          </label>
        </li>
        <li class="collection-item">
          <label class="line-through">
            <span>リスト</span><br>
            <span>作成日：yyyy年mm月dd日</span>
          </label>
        </li>
      </ul>
    </div>
  </div>
</template>
