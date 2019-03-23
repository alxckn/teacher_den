categories = ["devoirs", "info", "colles"]

seeds = [
  {
    name:   :users,
    seeded: ->() { User.find_by_email("admin@teacherden.eu").present? },
    up:     ->() { User.create(email: "admin@teacherden.eu", password: "beta2018", admin: true) },
    down:   ->() { User.destroy_all }
  },
  {
    name:   :categories,
    seeded: ->() { Category.find_by_label("colles").present? },
    up:     ->() { categories.each { |c| Category.create(label: c, displayable_name: c.capitalize ) } },
    down:   ->() { Category.destroy_all }
  },
  {
    name:   :articles,
    seeded: ->() { Article.any? },
    up:     ->() do
      unpublished = Article.create(title: BetterLorem.w(1, true).capitalize, content: BetterLorem.w(20, true), private: false, status: :unpublished)
      published   = Article.create(title: BetterLorem.w(1, true).capitalize, content: BetterLorem.w(20, true), private: false, status: :published)
      expired     = Article.create(title: BetterLorem.w(1, true).capitalize, content: BetterLorem.w(20, true), private: false, status: :expired)
      private     = Article.create(title: BetterLorem.w(1, true).capitalize, content: BetterLorem.w(20, true), private: true, status: :published)

      multipart   = Article.create(title: BetterLorem.w(1, true).capitalize, content: BetterLorem.w(20, true), private: true, status: :published)
      part_1      = Article.create(parent: multipart, title: BetterLorem.w(1, true).capitalize, content: BetterLorem.w(20, true), private: true, status: :published)
      part_2      = Article.create(parent: multipart, title: BetterLorem.w(1, true).capitalize, content: BetterLorem.w(20, true), private: true, status: :published)
    end,
    down:   ->() { Article.destroy_all }
  },
  {
    name:   :documents,
    seeded: ->() { Document.any? },
    up:     ->() do
      file = File.open(File.join(Rails.root, "vendor", "pdf-test.pdf"))
      categories.each { |cat| Document.create(category: Category.find_by_label(cat), file: file) }
      file.close
    end,
    down:   ->() { Document.destroy_all }
  }
]

rollback = ENV["ROLLBACK"]
seeds = seeds.reverse if rollback

seeds.each do |seed|
  if !rollback && seed[:seeded].call
    ActiveRecord::Migration.say "Already seeded: #{seed[:name]}"
  else
    text = rollback ? "Rolling back" : "Migrating"
    action = rollback ? :down : :up
    ActiveRecord::Migration.say_with_time("#{text} #{seed[:name]}") do
      seed[action].call
    end
  end
end
