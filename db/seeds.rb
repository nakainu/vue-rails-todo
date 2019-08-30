List.create!(
  [
    {
      name: '買い物リスト'
    },
    {
      name: 'レポート課題'
    }
  ]
)

Todo.create!(
  [
    {
      name: 'レポートサマリーを作る',
      list_id: 2
    },
    {
      name: 'レポートの表紙を作る',
      is_done: true,
      list_id: 2
    }
  ]
)
