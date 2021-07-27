require 'redcarpet'


md = Redcarpet::Markdown.new(Redcarpet::Render::HTML, no_intra_emphasis: true, fenced_code_blocks: true, autolink: true, superscript: true, underline: true)


entries = [
  {
    title: 'Programming WTF',
    created_at: '2021-02-11',
    updated_at: '2021-02-11',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "<p>
  I started programming long before I started coding. Programming is often
  mis-defined. It’s not writing software code — that’s coding. Programming is
  what enables coding to do the amazing things it does.
</p>

<p>Programming is a thought process.</p>

<p>
  To put it simply, programming is a trained skill that involves three steps:
</p>

<ol>
  <p>Evaluate what the problem is. It’s impossible to solve a problem that hasn’t been definitively identified. Sometimes this can surprise you. For example, the problem with heavy traffic jams in one part of the city may initially seem to be too many cars on the road, but upon further inspection could be simply that a few stoplights in the middle of town are poorly timed for optimum traffic flow. Look into the problem and identify all possible causes. Then look closer at those causes and see if any of them are actually contributing to the issue. Once these have been identified, move on to step number two.</p>
  <p>Clearly decide what the situation will look like once the issues are resolved. Plan this out as detailed as possible. Draw it, graph it, outline it, or whatever is needed for you to know exactly how it should be. Spare no detail — the more precisely you perform this step, the more accurately you can achieve the desired result.</p>
  <p>Figure out how to get from point #1 to point #2. Oftentimes this involves multiple false starts and retries. The important part here is to keep moving. Don’t be afraid to scrap everything and start over. Many times during this stage you may find that your #1 answer wasn’t the actual root problem at all. That’s ok. Keep moving, don’t get discouraged. Measure your progress not by how much you have done or how much you have left to do, but simply by whether or not you can still take another step forward. If so, you are making progress.</p>
  <p>Trust yourself. You saw the problem. You saw the final result. The solution will come to you.</p>
</ol>

<p>
  And that’s it! Programming, once correctly defined, is actually something we
  all do in almost every situation every day of our lives. Anyone can program.
  Coders just train that thought process and apply it to writing languages that
  computers understand.
</p>",
  },
  {
    title: 'Redux + Nextjs WTF',
    created_at: '2021-02-18',
    updated_at: '2021-02-18',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "Redux and Nextjs are two very powerful tools for a web developer comfortable with React. Redux allows for one central store for all the state needs throughout an entire application. Nextjs is a framework designed for Server-Side Rendering (SSR) — opening the door for better SEO and faster load times. Individually, these tools can supercharge your web app. It then seems logical that used together, your app could rule the world.

The problem is: Redux and Nextjs don’t seem to play very well together.

This is not to say that using them together to get the specific features you want from each library is not possible; it’s just complicated.

For that reason, I’d like to cover one of the more difficult parts of a Redux/Nextjs design that I’ve encountered: dynamic urls.

Nextjs provides a simple-ish way to deal with dynamic urls. For this example, we’ll assume that the urls you are looking for match the pattern example.com/blog/:slug, where :slug is the dynamic part of the url. We’ll also assume that you’re using the next-redux-wrapper from kirill-konshin (which seems to be the almost-universally accepted package for dealing with this pair-up), and that you’ve followed the basic setup instructions on both nextjs.org and kirill’s GitHub.

    In your pages folder, create a folder called blog
    In your pages/blog folder, create a file called index.js
    In pages/blog/index.js create your basic Post component. Mine looks like:

const Post = props => {
  const { post } = props
  const { title, content, created_at, updated_at } = post  return (
    <article>
      <h2>{title}</h2>
      <h6>{(created_at === updated_at) ? 'Posted at' : 'Updated at'} {updated_at}</h6>
      <p>{content}</p>
    </article>
  )
}export default Post

4. Within the same file (but outside of your Post component), export an asynchronous function called getStaticPaths

import { store } from '/path/to/store/setup/according/to/kirills/instructions'export const getStaticPaths = async () => {
  let posts = store.getState().posts
  if (posts.length < 1) {
    const postAction = await store.dispatch(fetchAllPosts())
    posts = postAction.payload.posts
  }  const paths = posts.map(post => (
    {
      params: {
        slug: post.slug,
      },
    }
  ))  return {
    paths,
    fallback: true,
  }
}

Note that for getStaticPaths to have access to the store, you must import it directly from your store setup file (or create it in this file, which is not recommended due to complexity). This is because getStaticPaths is one of the first functions run from this page (during SSR), and next-redux-wrapper does not provide a wrapper for getStaticPaths. Also, I chose fallback: true because I have a custom display if someone types in a url referencing a post that doesn’t exist (not featured here). You could set it to false if you prefer to throw a 404 instead. fetchAllPosts is a function in postActions that handles all the fetching from the API.

5. getStaticPaths requires that you also export the asynchronous function getStaticProps

import { storeWrapper } from '/path/to/store/setup/according/to/kirills/instructions'const getStaticProps = storeWrapper.getStaticProps(
  async ({ store, params }) => {
    let post
    if (store.getState().posts && store.getState().posts.length > 1) {
      post = store.getState().posts.filter(post_ => post_.slug === params.slug)[0]
    } else {
      const response = await fetch(`api.domain/posts/${params.slug}`, {
        method: 'GET',
        mode: 'cors',
        headers: {
          'Content-Type': 'application/json',
        },
      })      post = await response.json()
    }    return {
      props: {
        post,
      },
    }
  }
)

Notice that this function is wrapped with the function you created in kirill’s setup (which I renamed as storeWrapper instead of wrapper for clarity). The store this function receives is that store (which is the same one you imported in the previous function). The params variable comes from getStaticPaths.

That’s pretty much it. You’ll set up your actions and reducers as normal for redux with one exception: your actions must actually return the dispatched action objects, not just simply dispatch them.

As you can see, setting up Redux with Nextjs takes a few extra tweaks, but it’s not too bad. Once you’re finished, the end result is quite amazing: pages rendered server side with a single source of truth for managing state in all your pages.

Happy coding!",
  },
  {
    title: 'Debugging WTF',
    created_at: '2021-02-25',
    updated_at: '2021-02-25',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "Debugging can often be one of the biggest four-letter words in software development. But it shouldn’t be. For one, debugging happens. Every project ever coded will need to be debugged, because every project ever coded will mess up in some way or another, at least once (usually multiple times). Also, debugging teaches you more about how your code actually works than all the tutorials and classes put together. For that reason, here are some tips to help make debugging a little smoother and hopefully more fun.

    READ every error message. Don’t just skim it, or say, “I have an error” then immediately ask for help or drop your code. Most error messages have a huge amount of information for you, and many are fairly straightforward. Sometimes they tell you exactly where in your code the issue lies. If not, then they usually tell you at least the ballpark area where your code failed, allowing you to zero in on it from there.
    Read the full stack trace. You may not want to do this every time, but at least every so often, you should read the full stack trace beginning to end. This helps you figure out the order in which the various pieces of your code are running, and the dependencies within that flow. Keep in mind that the actual failure point (your error) may be at either the top OR the bottom of the trace, depending on the language/framework you are using.
    Try to see if you can solve the issue by yourself before googling the answer or reaching out for help. Most people learn far more from their own mistakes than any other training experience. You’re a better coder than you think. If you understood the information #1 and #2 gave you even a little bit, then you probably have at least an idea of where to look to fix your code. Start there.
    Master Google-Fu. Whatever your favorite search engine, it is your best friend. If you can’t figure it out on your own, start searching for answers by copy/pasting the error message (just the error message, discerned in #1 above — don’t paste the entire stack). If your fortunate, you may get results that exactly match your situation. Most likely, you will need to read posts and articles that kind of match what you’re facing, sometimes many of them. The more you understand what your code SHOULD be doing and what it is ACTUALLY doing, the more you can filter out the information that doesn’t apply and apply that which does.
    Ask. For. Help! This is not weakness or some symbol of failure as a developer/person/self-sufficient living organism. Identify the person or group of people most accessible to you who are most likely to answer the questions you have, explain your situation (politely and without complaining), and ask for insight. Then be open to the answers you receive. You may not like those answers. You may be told to completely rewrite your entire codebase. Accept it with a grain of salt, be gracious in your thanks, and again filter out the information that does not actually apply to your unique issue.
    Rinse and repeat. Continue cycling through steps 1–3 until you find the answers you are looking for. Don’t spend too much time on any one step. If you stop making progress on one step, move on to the next, or start the process over, somewhat differently. Search for different but related terms, ask different people, reread your code, etc. Go back to when your code worked (version control like Git makes this much simpler) and trace through it manually until you find what went wrong.
    Manage your emotions. Don’t snap at people trying to help you, even if they are completely wrong. Don’t berate yourself. You know what you are doing, and troubleshooting is a natural part of coding that all developers face. And if you get frustrated, walk away for a while. Go watch a movie, take a shower or a walk, play a game, something. Anything that is not actively looking at the problem. You’ll be amazed how often that will be the moment the solution comes to you.

The most important thing about debugging is your attitude. See the issue as a challenge that you will overcome, and that is exactly what you will do. Happy coding!"
  },
  {
    title: 'Imposter Syndrome WTF',
    created_at: '2021-03-04',
    updated_at: '2021-03-04',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "Imposter Syndrome is the name for the feeling of “I don’t belong here; I’m not good enough” that many of us know all too well. It can show up anywhere in anyone, but seems to be most often referenced within the Software world. But it’s not unique to developers.

I am currently in the job-hunting phase of my transition into Software Development, yet I have still dealt with this feeling multiple times. Transitioning into the military I dealt with it. I wasn’t big or strong like my peers. I am not an alpha personality. Yet, I am capable of extraordinary stubbornness, and I continued on.

Each time I was transferred to a different area of responsibility within the military, I felt it. Yet, I believe I can learn (almost) anything quickly, so I continued on.

When I separated from the military into the entirely different world of Civilian and had to find a non-entry-level job for the first time, I felt it. But I had to provide for my family, so I pushed through the piles of applications and eventually landed a maintenance job.

At that job, when I worked alone for the first time, I felt it. But I had no one else to call on for help, so I figured things out on my own. Whether the solutions I came up with were the optimal ones or not, I found out later. But I still found those solutions even though I felt like I had no idea what I was looking at.

And even now, as I search for Software Development jobs, I have felt it. It got especially strong after I had been rejected by a few places and ignored by almost all the rest. I thought, “I obviously don’t stand out; what am I doing wrong?”

The answer frustrated me. Nothing. I was not doing anything wrong. I was checking all the boxes, reaching out to people, not companies, applying to the companies of everyone I reached out to, and doing this several times a day. So I started to think that maybe I’m not as good at coding as I thought. But I knew that was a lie. I am a very talented coder, even if I am inexperienced. All the feedback I got during school said as much and more.

So what was the real answer? My attitude. My belief that this process should be easier than it is, and that I was somehow insufficient because there are difficulties, *that* was what I was doing wrong.

So what is the solution? It’s simple (though simple and easy are not the same thing): believe in myself. Yes, that sounds like a fortune cookie, but it is true. Proverbs says that what we think in our hearts is who we are. Translation: you are who you believe you are. Are you good enough? Do you know enough? Can you handle this? If you believe yes, then yes. You may not know how yet, but you know you can. However, if you believe no, then no amount of help, training or practice will ever change the fact that you are not good enough, because you will always be only as good as you believe you are.

So, believe in yourself first. The how will come after you have settled that, and you will succeed at everything your hand touches. Happy coding!",
  },
  {
    title: 'Git WTF',
    created_at: '2021-03-11',
    updated_at: '2021-03-11',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "Git is, according to git-scm.org, “a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.” But what does that mean? And why should you know it as a coder?

To put it simply, git is what you use to both save and share your work. Think about it this way: you know how you always hear, “Save often”? Well, what does that really mean when coding? I mean, you have to save your work to even see the results of whatever changes you made anyway. And if you save junk code that breaks your project, then what? Rolling back to a previously saved version can be tough or even impossible, depending on your system.

So, what do you do? Manually go through your code and revert all the changes you made, one by one? On a small project where you have only made a few changes, that might work. But even a “small” project can quickly become too large to feasibly pull this off. Not to mention the massive amount of time you waste in the process.

That’s where git (or any version control software) comes in. Essentially, it “saves” your record of saves for each file in your project, and allows you to revert all of them at once to whatever point in time you “saved” them (the real term is “committed”). For example, say you are working on a Next.js website, /myapp, and you decide to add a new page with a dynamically generated url, /myapp/some_extra_feature, with some_extra_feature being the dynamic part. You create the necessary extra files: touch /pages/[some_extra_feature].js /styles/some_extra_feature.module.css. You spend an hour writing and perfecting the code and layout, testing as you go, and you are very satisfied. With one final lookover of your newly-expanded project, you glance at the project requirements and realize: oh no. The dynamic url is supposed to look like /myapp/some_extra_feature/this_is_the_dynamic part! What to do? Sure you could just create the pages/some_extra_feature/ folder, rename some_extra_feature.js, rename some_extra_feature.module.css, change all your imports, and re-test the code, tweaking it line by line to verify it still performs the correct functions, but wouldn’t it be easier if you could just go back to the working model you had before you added this feature and start again? If you committed to git at that point, you can.

The other major use for git is the ability to share your work. Your commits are stored in what is called a repository. Git (and GitHub, which uses git) allows you to easily send a repository to a central storage place (like GitHub), provide the link/address to your partner/mentor/trainee/etc. and they can simply pull (more on this below) it to their machine and work with your code exactly as you committed it. Quick and easy!

To master git there are tons of commands you should learn. But you don’t need to master it to be able to reap these benefits I have mentioned. You only need a handful — the most common ones.

git status — this does what it says: it tells you the status of your repositiory (repo). It categorizes all the files of your repo into one of three categories: will be committed, changes not committed, and untracked changes. Anything categorized as will be committed will be “saved” as discussed above.

git add — allows you to re-categorize any files listed as changes not committed or untracked changes to will be committed.

git commit — actually performs the “save”

git clone — copy all files from a repo into a new repo on your local machine

git pull — get the current up-to-date version of the repo you cloned FROM

git push — change the repo you pulled/cloned FROM into the current up-to-date version of the repo you cloned TO

git reset — careful with this one, read the docs about it. This allows you to cancel work you’ve done to return to a previous point in time. Again, BE CAREFUL, as careless usage of this can cost you hours of work.

There are many more commands for git. Once you are comfortable with these basic commands, I suggest you next learn about git branch, git checkout, and git merge. Trust me, by this point you will have a firm grasp on how to NOT lose your entire week’s work when your younger sister trips on your charging cable and simultaneously power cycles your laptop while pouring an entire smoothie into the cooling port.

Happy coding!"
  },
  {
    title: 'Counting Sort WTF',
    created_at: '2021-03-18',
    updated_at: '2021-03-18',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "In preparation for this weekend’s Kick Start Hackathon held by Google, I started going through last year’s questions. The very first one I came to gave me difficulty. Given a set budget amount and a list of house prices, calculate the maximum number of houses you can buy. The logic seemed simple enough, and I quickly had a solution worked out in Ruby.

The difficulty came with the speed requirement: no more than 15 seconds per test set. When you think in the realm of realism, that is plenty of time. Kick Start, however, never stick to just “realistic” data sets. With a possible $100,000 to work with, house prices $1000 and below (wouldn’t that be nice!), and a possible 100,000 houses to choose from, the test sets get quite large. Large enough that the typical O(n log n) time complexity of Ruby’s built-in sort method times out and the answer fails.

After much Google-fu, I came across the counting sort. After much more, I found an explanation that didn’t require a Ph.D. in high-level mathematics to understand. Here is my attempt at re-explaining it in a much more vernacluar style:

Let’s say you have an array: arr = [1, 5, 3, 5, 2, 1] that you need to sort. The first thing you need to do is count how many of each value you have, and match it to an index that corresponds to the value being counted.

We’ll start with an array of the same length as the maximum value found in arr, initialized to 0 for each value:

max_value = arr.maxcounts = [0] * (max_value + 1)

Then we count each value in arr and set the value at the matching index in counts to that count:

arr.each {|val| counts[val] += 1}

counts now equals [0, 2, 1, 1, 0, 2]. This translates to: “The sorted array will have 0 zeroes, then 2 ones, then 1 two, then 1 three, then 0 fours, then 2 fives.”

Now we use counts to re-factor counts on top of itself. The new version will hold values that match the number of values that precede that index value in the original arr. I’ll explain that better below:

num_items_before = 0counts.each_with_index{|count, index|
  counts[index] = num_items_before
  num_items_before += count
}

This changes counts to [0, 2, 3, 4, 4, 6]. This translates to: “fill up the sorted array with zeroes until before index 0 (which doesn’t exist, so 0 places), then fill with ones until before index 2 (two places), then fill with twos until before index 3 (one place), then fill with threes until before index 4 (one place), then fill with fours until before index 4 (same as before, so 0 places), then fill with fives until before index 6 (the end of the array, so 2 places). This seems strange, but these extra steps prevent having to re-iterate through arr multiple times, saving time in exchange for the extra space needed for counts. Also, re-factoring counts on top of itself saves some additional space needed for a third array.

Finally, we create the sorted array from the new counts and return it:

sorted_array = [0] * arr.lengtharr.each{|val|
  sorted_array[counts[val]] = val
  counts[val] += 1
}sorted_array

The incrementing of counts[val] allows for multiples of each value.

This returns [1, 1, 2, 3, 5, 5]. The best part is that this whole thing runs in O(n) timplexity and O(n) space complexity.

Happy coding!",
  },
  {
    title: 'Next.js + Heroku WTF',
    created_at: '2021-03-22T02:18:19.080Z',
    updated_at: '2021-03-22T02:18:19.080Z',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "After TWO WEEKS of R10 errors, I finally have my site up with my blog! Special thanks to Derik Linch for the answer! It turns out, deploying a Next.js app to Heroku requires one simple modification, not covered ANYWHERE on Google. In your `package.json` file, NOT in a `Procfile` as the official website discusses, replace this line: `\"start\": \"next start\"` with this one: `\"start\": \"next start -p $PORT\"` THAT'S IT! I am not sure why Heroku needs that slight modification (instead of it being built in), but I am ecstatic that it works! That's all this week. Happy coding!",
  },
  {
    title: 'Design vs Development WTF',
    created_at: '2021-04-02T04:40:14.240Z',
    updated_at: '2021-04-02T04:40:14.240Z',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "This post is more of a rant than a how-to, so please bear with me. I taught myself to code several years ago, and only last year attended a boot camp to get a more formal perspective. Through the whole process I have found a few issues with self-teaching. Number one on my mind right now is this: For both designers and developers, there are essentially two levels of instruction to be found online: absolute noob and supreme master. Once a self-teacher has surpassed the basics, the next level of instruction usually involves in-depth dives into advanced topics, or costs several hundred dollars (or more). Essentially, the message becomes, \"you have completed the tutorial level. If you would like to continue, you must purchase the game. Note: free levels are awarded upon reaching level 1000.\" So that I am not simply whining, I have decided upon a solution. I will provide a tutorial series for intermediate programmers and designers. I don't know when I will start this yet, because I have several higher-priority projects I'm working on now, but I will do it. Keep watching, and I will notify you when the tutorial series is about to begin. (By the way, the tutorial will be totally free.) Happy coding!",
  },
  {
    title: 'Project Priorities WTF',
    created_at: '2021-04-08T17:25:41.359Z',
    updated_at: '2021-04-08T17:25:41.359Z',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "If you look at my Portfolio page, you will see that I only have two projects listed. And if you look at those, you will see that they are somewhat basic. Yet my resume lists a few more. The reason for all this is that deployment is tough, and seems to be a unique process for each project. That is a topic for a different post, though. For this one, I want to talk about project priorities. I have all those projects to deploy, I'm totally revamping the Calapitter Image Library from the ground up, I have yet to finish ButterflyPaint, and this website is incomplete (I want to add the ability to post comments). I'm sure there are many more tasks I've assigned myself that I'm not thinking about right now. Point is, if I allow myself to continue to stack up technical debt without completing anything, I will just continue to increase my stress. I need a priority list, an order to tackle each goal, one at a time, until all are complete. So going forward, here is my priority order, officially written down: 1) Complete and deploy a working MVP of ButterflyPaint, written tests-first. 2) Finish conversion of CIL revamp to TDD, then finish and deploy MVP. 3) Add comments and user avatars to website. 4) Revamp and re-deploy Yeti The Bookclub App. 5) Deploy Recipe Calculator. 6) Fine-tune all aforementioned projects. 7) TBD. So what does this mean for you and this blog? I will continue to post every week, but there will be no other updates or changes to this website until I reach that step, and projects will be added slowly to my Portfolio (for now). Thank you for understanding, and happy coding!",
  },
  {
    title: 'TDD WTF',
    created_at: '2021-04-15T23:54:20.419Z',
    updated_at: '2021-04-15T23:54:20.419Z',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "Test-Driven Development (TDD) is a very popular coding method currently. But what is TDD? Essentially, it means that a coder first writes a test for an expected result, which fails immediately, then writes the minimum amount of code necessary to make the test pass. It seems backwards, but I recently dove into this style, and honestly, I love it. Also known as the \"red-green-refactor\" method (because when the tests fail the results are usually displayed in red type and when they pass in green, so you see red first, then green, then you refactor the code as needed), this style actually helps keep your code minimal and efficient. This means less (or no) spaghetti code, and no dead code. Starting can seem intimidating, though, especially for new coders. \"How can I know what to test for if I haven't written it yet?\" The trick to understanding this, though, is that you are not writing tests based on nothing. You write tests that look for the results you want your code to produce. Then it's simply a matter of figuring out how to get there. RSpec (for Rails) is a great introduction to TDD, and I will cover that in my next post. Happy coding!"
  },
  {
    title: 'RSpec WTF',
    created_at: '2021-04-23T02:15:09.260Z',
    updated_at: '2021-04-23T02:15:09.260Z',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "As I mentioned in my previous post, RSpec is a wonderful tool for learning Test-Driven Development (TDD). It should be noted that on RSpec's website, it refers to itself as a Behavior-Driven Development (BDD) tool. The difference between these two terms is slight, so for the purpose of this post, treat both as the same, and I will refer to both as TDD/BDD. The first thing to know about RSpec is that it is a Ruby gem, so if you are using a different language, there are most likely multiple options for testing your specific language, but the principles should be the same. Because RSpec is a gem, it can be installed by simply running `gem install rspec` in your terminal or by adding `gem 'rspec'` to your project's `Gemfile` then running `bundle install`. Once RSpec is installed, it's time to write your tests, or 'specs' as RSpec calls them. These are usually stored in a `specs` folder in the root of your project. Split your specs up by functional area, and be sure that each spec filename ends with `_spec`. Don't worry; we'll go through a simple example now: Create a new folder called `rspec_example`. Inside it, create a file called `example.rb` and a file called `example_spec.rb`. In `example_spec.rb` type the following: ``` require 'rspec' require_relative './example' RSpec.describe 'example' do it \"returns 'Hello, World!'\" do expect(hello_world()).to eq('Hello, World!') end end ``` What this means should be fairly self-explanatory, as RSpec is designed to almost mirror normal speech. The `eq` stands for 'equal' and uses the `==` operator to compare the result of the method called inside `expect` (`hello_world()`) with the value inside `eq` (`'Hello, World!'`). If they are equal, the spec passes, and if not it fails. Save and run `rspec example_spec.rb` from your console. It should fail with an error message: \"NoMethodError: undefined method `hello_world' for #<RSpec::ExampleGroups::Example:0x00000000022ae188>\" or something like it. This is good. This is saying that we have no method `hello_world` in `example.rb`, which we don't because we haven't created it. Let's do that now. In `example.rb` create a method `hello_world` like so: ``` def hello_world end ``` Don't worry about having it do anything yet. Just save and run `rspec example_spec.rb` again. Now we see this message: ``` F Failures: 1) example returns 'Hello, World!' Failure/Error: expect(hello_world()).to eq('Hello, World!') expected: \"Hello, World!\" got: nil (compared using ==) # ./example_spec.rb:6:in `block (2 levels) in <top (required)>' Finished in 0.18145 seconds (files took 0.07452 seconds to load) 1 example, 1 failure Failed examples: rspec ./example_spec.rb:5 # example returns 'Hello, World!' ``` This actually tells you a lot. The red 'F' at the top tells you that one spec failed. We only wrote one spec, but if you had more, there would be a red 'F' for each failure and a green '.' for each pass. The information after the '1)' tells you which spec failed, what was expected and what was actually received by the `expect` in our spec. We see that it expected to receive `'Hello, World!'` but actually received `nil`. We aren't returning anything from our method yet, so that makes sense. We need to write more. Back in `example.rb` change `hello_world` to match the following: ``` def hello_world 'Hello, World!' end ``` Then save and run `rspec example_spec.rb` one more time. A green dot! And look, zero failures! Congratulations! You have written your first test using RSpec, and written it in a TDD/BDD way. Now go, read the docs and expand your ability to use this wonderful tool for your own projects. Happy coding!",
  },
  {
    title: '-ism WTF',
    created_at: '2021-06-22T17:19:50.015Z',
    updated_at: '2021-06-22T17:19:50.015Z',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "I apologize for not posting in a long time. Life has been rather overwhelming lately, but everything is moving forward smoothly once more. I also apologize for the deviation in this post from my normal. I wanted to address the various '-ism's that seem to run rampant in the world today: sexism, classism, racism, any fill-in-the-blank form of denegration, segregation and malice. In my opinion, they all come down to one thing, what I call the 'Us vs Them' mentality, i.e. \"They are Them and We are Us; Us is better than Them and will always be better, therefore Them do not have the same rights to respect, love, opportunities, or a generally good life as Us do, because Us will always reign Supreme.\" In any situation, if one feels that they must justify their own existence and/or beliefs exclusively in contrast to another's, there is something fundamentally wrong with their viewpoint. I am Me. I have my own Beliefs, and my Existence within those Beliefs does not depend on You. You have different Beliefs and a separate Existence. There are things We disagree on. There are things We agree on. There are thing I can learn from You. There are things You can learn from Me. Together, We can achieve far greater things than either of Us can alone. Apart, one may rise, one may fall, both may rise, or both may fall. But the effect will never be as great os if both rise Together. ***BTW all capitalization is for emphasis, in case it looks weird.***",
  },
]


BlogEntry.destroy_all

for entry in entries do
  entry[:content] = md.render(entry[:content]).gsub("\n", '<br />')

  BlogEntry.create!(entry)

  puts 'BlogEntry created!'
end
