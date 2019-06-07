# Project: Micro-Reddit (Ruby on Rails)

This is the fourth project of the Main Rails curriculum at [Microverse](https://www.microverse.org/) - @microverseinc

- The objective is to build the data structures necessary to support link submissions and commenting.
- A front end is not built for it, the Rails console is used to play around with models without the overhead of making HTTP requests and involving controllers or views.

#### [Assignment link](https://www.theodinproject.com/courses/ruby-on-rails/lessons/building-with-active-record-ruby-on-rails#project-2-micro-reddit)

### Micro-Reddit (Ruby on Rails)

#### More about the project

##### Relationship

```
- Post `belongs_to` User
- Comment `belongs_to` User
- Comment `belongs_to` Post
- User `has_many` posts
- User `has_many` comments
- Post `has_many` comments
```

##### Validations

```
User
- `name` can not be blank and can not exceed 100 characters
`username` can not be blank and can not exceed 30 characters

Post
- `title` can not be blank, can not exceed 126 characters and must be unique
- `body` can not be blank and can not exceed 2000 characters

Comment
- `body` can not be blank and can not exceed 256 characters
```

## Usage Instructions

### Clone the project

- Clone the repo and run the app.

```bash
$ git clone git@github.com:bolah2009/micro-reddit.git
$ cd micro-reddit

```

### Run bundle install and migrate as follows:

```bash
bundle install

rails db:migrate
```

### Run the rails console

```bash
rails console

Running via Spring preloader in process 16931Loading development environment (Rails 5.2.3)
```

### Create a user and check for validations

```bash
irb(main):001:0> u1 = User.new
=> #<User id: nil, name: nil, username: nil, created_at: nil, updated_at: nil>

irb(main):002:0> u1.valid?
=> false

irb(main):003:0> u1.errors
=> #<ActiveModel::Errors:0x00007f77ec4d43b8 @base=#<User id: nil, name: nil, username: nil, created_at: nil, updated_at: nil>, @messages={:name=>["can't be blank"], :username=>["can't be blank"]}, @details={:name=>[{:error=>:blank}], :username=>[{:error=>:blank}]}>

irb(main):004:0> u1.name = "Sergio"
=> "Sergio"

irb(main):005:0> u1.username = "Cheif"
=> "Cheif"

irb(main):006:0> u1.valid?
=> true

irb(main):007:0> u1.save
   (0.1ms)  begin transaction
  User Create (4.2ms)  INSERT INTO "users" ("name", "username", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["name", "Sergio"], ["username", "Cheif"], ["created_at", "2019-06-06 22:48:54.533753"], ["updated_at", "2019-06-06 22:48:54.533753"]]
   (28.8ms)  commit transaction
=> true
```

### Create a post and check for validations

```bash
irb(main):008:0> p1 = Post.new
=> #<Post id: nil, title: nil, body: nil, user_id: nil, created_at: nil, updated_at: nil>

irb(main):009:0> p1.valid?
  Post Exists (0.8ms)  SELECT  1 AS one FROM "posts" WHERE "posts"."title" IS NULL LIMIT ?  [["LIMIT", 1]]
=> false

irb(main):010:0> p1.errors
=> #<ActiveModel::Errors:0x00007f77ec613058 @base=#<Post id: nil, title: nil, body: nil, user_id: nil, created_at: nil, updated_at: nil>, @messages={:user=>["must exist"], :title=>["can't be blank"], :body=>["can't be blank"]}, @details={:user=>[{:error=>:blank}], :title=>[{:error=>:blank}], :body=>[{:error=>:blank}]}>

irb(main):011:0> p1.title = "First Post"
=> "First Post"

irb(main):012:0> p1.body = "This is the first post"
=> "This is the first post"

irb(main):013:0> p1.user_id = 1
=> 1

irb(main):014:0> p1.valid?
  User Load (0.6ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  Post Exists (0.7ms)  SELECT  1 AS one FROM "posts" WHERE "posts"."title" = ? LIMIT ?  [["title", "First Post"], ["LIMIT", 1]]
=> true
```

### Associate post with User model (one-to-many) and check if duplicate post title is valid

```bash
irb(main):015:0> p2 = User.first.posts.build
  User Load (0.4ms)  SELECT  "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT ?  [["LIMIT", 1]]
=> #<Post id: nil, title: nil, body: nil, user_id: 1, created_at: nil, updated_at: nil>

irb(main):016:0> p2.title = "Second Post"
=> "Second Post"

irb(main):017:0> p2.body = "This is the second post"
=> "This is the second post"

irb(main):018:0> p1.save
   (0.1ms)  begin transaction
  Post Exists (0.4ms)  SELECT  1 AS one FROM "posts" WHERE "posts"."title" = ? LIMIT ?  [["title", "First Post"], ["LIMIT", 1]]
  Post Create (1.6ms)  INSERT INTO "posts" ("title", "body", "user_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["title", "First Post"], ["body", "This is the first post"], ["user_id", 1], ["created_at", "2019-06-06 23:04:42.130262"], ["updated_at", "2019-06-06 23:04:42.130262"]]
   (25.2ms)  commit transaction
=> true

irb(main):019:0> p2.save
   (0.1ms)  begin transaction
  Post Exists (0.7ms)  SELECT  1 AS one FROM "posts" WHERE "posts"."title" = ? LIMIT ?  [["title", "Second Post"], ["LIMIT", 1]]
  Post Create (3.8ms)  INSERT INTO "posts" ("title", "body", "user_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["title", "Second Post"], ["body", "This is the second post"], ["user_id", 1], ["created_at", "2019-06-06 23:04:47.343130"], ["updated_at", "2019-06-06 23:04:47.343130"]]
   (81.8ms)  commit transaction
=> true

irb(main):020:0> User.first.posts
  User Load (0.5ms)  SELECT  "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT ?  [["LIMIT", 1]]
  Post Load (0.8ms)  SELECT  "posts".* FROM "posts" WHERE "posts"."user_id" = ? LIMIT ?  [["user_id", 1], ["LIMIT", 11]]
=> #<ActiveRecord::Associations::CollectionProxy [#<Post id: 1, title: "First Post", body: "This is the first post", user_id: 1, created_at: "2019-06-06 23:04:42", updated_at: "2019-06-06 23:04:42">, #<Post id: 2, title: "Second Post", body: "This is the second post", user_id: 1, created_at: "2019-06-06 23:04:47", updated_at: "2019-06-06 23:04:47">]>

irb(main):021:0> p3 = Post.new(title: "First Post", body: "This is the first post again, hope it doesn't pass validation", user_id: 1)
=> #<Post id: nil, title: "First Post", body: "This is the first post again, hope it doesn't pass...", user_id: 1, created_at: nil, updated_at: nil>

irb(main):022:0> p3.valid?
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  Post Exists (0.2ms)  SELECT  1 AS one FROM "posts" WHERE "posts"."title" = ? LIMIT ?  [["title", "First Post"], ["LIMIT", 1]]
=> false

irb(main):023:0> p3.errors
=> #<ActiveModel::Errors:0x00007f77d804fe78 @base=#<Post id: nil, title: "First Post", body: "This is the first post again, hope it doesn't pass...", user_id: 1, created_at: nil, updated_at: nil>, @messages={:title=>["has already been taken"]}, @details={:title=>[{:error=>:taken, :value=>"First Post"}]}>
```

### Create a comment and check for validations

```bash
irb(main):024:0> c1 = Comment.new(user_id: 1, post_id: 1, body: "This is my very first comment")
=> #<Comment id: nil, body: "This is my very first comment", user_id: 1, post_id: 1, created_at: nil, updated_at: nil>

irb(main):025:0> c1.save
   (0.1ms)  begin transaction
  User Load (0.7ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  Post Load (0.2ms)  SELECT  "posts".* FROM "posts" WHERE "posts"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  Comment Create (1.8ms)  INSERT INTO "comments" ("body", "user_id", "post_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["body", "This is my very first comment"], ["user_id", 1], ["post_id", 1], ["created_at", "2019-06-06 23:16:47.821338"], ["updated_at", "2019-06-06 23:16:47.821338"]]
   (27.8ms)  commit transaction
=> true

irb(main):026:0> c2 = Comment.new
=> #<Comment id: nil, body: nil, user_id: nil, post_id: nil, created_at: nil, updated_at: nil>

irb(main):027:0> c2.user_id = 1
=> 1

irb(main):028:0> c2.post_id = 1
=> 1

irb(main):029:0> c2.valid?
  User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  Post Load (0.2ms)  SELECT  "posts".* FROM "posts" WHERE "posts"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
=> false

irb(main):030:0> c2.errors
=> #<ActiveModel::Errors:0x000055cd2d116700 @base=#<Comment id: nil, body: nil, user_id: 1, post_id: 1, created_at: nil, updated_at: nil>, @messages={:body=>["can't be blank"]}, @details={:body=>[{:error=>:blank}]}>

irb(main):031:0> c2.body = "a"*260
=> "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

irb(main):032:0> c2.valid?
=> false

irb(main):033:0> c2.errors
=> #<ActiveModel::Errors:0x000055cd2d116700 @base=#<Comment id: nil, body: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa...", user_id: 1, post_id: 1, created_at: nil, updated_at: nil>, @messages={:body=>["is too long (maximum is 256 characters)"]}, @details={:body=>[{:error=>:too_long, :count=>256}]}>

irb(main):034:0> c2.body = "Simple comment"
=> "Simple comment"

irb(main):035:0> c2.valid?
=> true
```

### Associations of comments with User and Post model (one-to-many)

```bash
irb(main):036:0> User.first.comments
  User Load (0.2ms)  SELECT  "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT ?  [["LIMIT", 1]]
  Comment Load (0.4ms)  SELECT  "comments".* FROM "comments" WHERE "comments"."user_id" = ? LIMIT ?  [["user_id", 1], ["LIMIT", 11]]
=> #<ActiveRecord::Associations::CollectionProxy [#<Comment id: 1, body: "THis is a comment, ok?", user_id: 1, post_id: 1, created_at: "2019-06-06 21:58:21", updated_at: "2019-06-06 21:58:21">, #<Comment id: 2, body: "A", user_id: 1, post_id: 1, created_at: "2019-06-06 22:10:08", updated_at: "2019-06-06 22:10:08">, #<Comment id: 3, body: "This is my very first comment", user_id: 1, post_id: 1, created_at: "2019-06-06 23:16:47", updated_at: "2019-06-06 23:16:47">]>

irb(main):037:0> Post.first.comments
  Post Load (0.6ms)  SELECT  "posts".* FROM "posts" ORDER BY "posts"."id" ASC LIMIT ?  [["LIMIT", 1]]
  Comment Load (0.4ms)  SELECT  "comments".* FROM "comments" WHERE "comments"."post_id" = ? LIMIT ?  [["post_id", 1], ["LIMIT", 11]]
=> #<ActiveRecord::Associations::CollectionProxy [#<Comment id: 1, body: "THis is a comment, ok?", user_id: 1, post_id: 1, created_at: "2019-06-06 21:58:21", updated_at: "2019-06-06 21:58:21">, #<Comment id: 2, body: "A", user_id: 1, post_id: 1, created_at: "2019-06-06 22:10:08", updated_at: "2019-06-06 22:10:08">, #<Comment id: 3, body: "This is my very first comment", user_id: 1, post_id: 1, created_at: "2019-06-06 23:16:47", updated_at: "2019-06-06 23:16:47">]>
```

## Ruby version

    ruby 2.6.3p62

## Rails version

    Rails 5.2.3

#### Authors

- [@Torres-ssf](https://github.com/Torres-ssf)
- [@bolah2009](https://github.com/bolah2009/)
