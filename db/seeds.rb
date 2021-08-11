require 'redcarpet'


md = Redcarpet::Markdown.new(Redcarpet::Render::HTML, no_intra_emphasis: true, fenced_code_blocks: true, autolink: true, superscript: true, underline: true)


entries = [
  {
    title: 'Programming WTF',
    created_at: '2021-02-11',
    updated_at: '2021-02-11',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "<p>I started programming long before I started coding.</p><p>Programming is often mis-defined. It’s not writing software code — that’s coding. Programming is what enables coding to do the amazing things it does. Programming is a thought process. To put it simply, programming is a trained skill that involves three steps:</p><ol><li>Evaluate what the problem is. It’s impossible to solve a problem that hasn’t been definitively identified. Sometimes this can surprise you. For example, the problem with heavy traffic jams in one part of the city may initially seem to be too many cars on the road, but upon further inspection could be simply that a few stoplights in the middle of town are poorly timed for optimum traffic flow. Look into the problem and identify all possible causes. Then look closer at those causes and see if any of them are actually contributing to the issue. Once these have been identified, move on to step number two.</li><br /><li>Clearly decide what the situation will look like once the issues are resolved.Plan this out as detailed as possible. Draw it, graph it, outline it, or whatever is needed for you to know exactly how it should be. Spare no detail — the more precisely you perform this step, the more accurately you can achieve the desired result.</li><br /><li>Figure out how to get from point #1 to point #2. Oftentimes this involves multiple false starts and retries. The important part here is to keep moving. Don’t be afraid to scrap everything and start over. Many times during this stage you may find that your #1 answer wasn’t the actual root problem at all. That’s ok. Keep moving, don’t get discouraged. Measure your progress not by how much you have done or how much you have left to do, but simply by whether or not you can still take another step forward. If so, you are making progress. Trust yourself. You saw the problem. You saw the final result. The solution will come to you.</li></ol><p>And that’s it! Programming, once correctly defined, is actually something we all do in almost every situation every day of our lives. Anyone can program. Coders just train that thought process and apply it to writing languages that computers understand.</p><br />",
  },
  {
    title: 'Redux + Nextjs WTF',
    created_at: '2021-02-18',
    updated_at: '2021-02-18',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "<p>Redux and Nextjs are two very powerful tools for a web developer comfortable with React. Redux allows for one central store for all the state needs throughout an entire application. Nextjs is a framework designed for Server-Side Rendering (SSR) — opening the door for better SEO and faster load times. Individually, these tools can supercharge your web app. It then seems logical that used together, your app could rule the world.</p><p>The problem is: Redux and Nextjs don’t seem to play very well together.</p><p>This is not to say that using them together to get the specific features you want from each library is not possible; it’s just complicated.</p><p>For that reason, I’d like to cover one of the more difficult parts of a Redux/Nextjs design that I’ve encountered: dynamic urls.</p><p>Nextjs provides a simple-ish way to deal with dynamic urls. For this example, we’ll assume that the urls you are looking for match the pattern <code>example.com/blog/:slug</code>, where <code>:slug</code> is the dynamic part of the url. We’ll also assume that you’re using the next-redux-wrapper from <a href=&quot;https://github.com/kirill-konshin/next-redux-wrapper&quot;>kirill-konshin</a> (which seems to be the almost-universally accepted package for dealing with this pair-up), and that you’ve followed the basic setup instructions on both nextjs.org and kirill’s GitHub.</p><ol><li><p>In your pages folder, create a folder called <code>blog</code>.</p></li><li><p>In your pages/blog folder, create a file called <code>index.js</code></p></li><li><p>In <code>pages/blog/index.js</code> create your basic Post component. Mine looks like:</p><p><code><p>const Post = props =&gt; {<br />const { post } = props<br />const { title, content, created_at, updated_at } = post</p><p>return (<br />&nbsp;&nbsp;&lt;article&gt;<br />&nbsp;&nbsp;&nbsp;&nbsp;&lt;h2&gt;{title}&lt;/h2&gt;<br />&nbsp;&nbsp;&nbsp;&nbsp;&lt;h6&gt;{(created_at === updated_at) ? &#39;Posted at&#39; : &#39;Updated at&#39;} {updated_at}&lt;/h6&gt;<br />&nbsp;&nbsp;&nbsp;&nbsp;&lt;p&gt;{content}&lt;/p&gt;<br />&nbsp;&nbsp;&lt;/article&gt;<br />)<br /><br />export default Post</p></code></p></li><li><p>Within the same file (but outside of your Post component), export an asynchronous function called <code>getStaticPaths</code></p><p><code><p>import { store } from &#39;/path/to/store/setup/according/to/kirills/instructions&#39;</p><p>export const getStaticPaths = async () =&gt; {<br /><p>&nbsp;&nbsp;let posts = store.getState().posts</p><p>&nbsp;&nbsp;if (posts.length &lt; 1) {<br />&nbsp;&nbsp;&nbsp;&nbsp;const postAction = await store.dispatch(fetchAllPosts())<br />&nbsp;&nbsp;&nbsp;&nbsp;posts = postAction.payload.posts<br />&nbsp;&nbsp;}</p><p>&nbsp;&nbsp;const paths = posts.map(post =&gt; ({<br />&nbsp;&nbsp;&nbsp;&nbsp;params: {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;slug: post.slug,<br />&nbsp;&nbsp;&nbsp;&nbsp;},<br />&nbsp;&nbsp;}))</p><p>&nbsp;&nbsp;return {<br />&nbsp;&nbsp;&nbsp;&nbsp;paths,<br />&nbsp;&nbsp;&nbsp;&nbsp;fallback: true,<br />&nbsp;&nbsp;}<br /></p>}</p></code></p><p>Note that for <code>getStaticPaths</code> to have access to the store, you must import it directly from your store setup file (or create it in this file, which is not recommended due to complexity). This is because <code>getStaticPaths</code> is one of the first functions run from this page (during SSR), and <code>next-redux-wrapper</code> does not provide a wrapper for <code>getStaticPaths</code>. Also, I chose <code>fallback: true</code> because I have a custom display if someone types in a url referencing a post that doesn’t exist (not featured here). You could set it to false if you prefer to throw a <code>404</code> instead. <code>fetchAllPosts</code> is a function in <code>postActions</code> that handles all the fetching from the API.</p></li><li><p><code>getStaticPaths</code> requires that you also export the asynchronous function <code>getStaticProps</code></p><p><code><p>import { storeWrapper } from &#39;/path/to/store/setup/according/to/kirills/instructions&#39;</p><p>const getStaticProps = storeWrapper.getStaticProps(async ({ store, params }) =&gt; {<br /><p>&nbsp;&nbsp;let post</p><p>&nbsp;&nbsp;if (store.getState().posts &amp;&amp; store.getState().posts.length &gt; 1) {<br />&nbsp;&nbsp;&nbsp;&nbsp;post = store.getState().posts.filter(post_ =&gt; post_.slug === params.slug)[0]<br />&nbsp;&nbsp;} else {<br />&nbsp;&nbsp;&nbsp;&nbsp;const response = await fetch(&#96;api.domain/posts/${params.slug}&#96;, {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;method: &#39;GET&#39;,<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;mode: &#39;cors&#39;,<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;headers: {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&#39;Content-Type&#39;: &#39;application/json&#39;,<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;},<br />&nbsp;&nbsp;&nbsp;&nbsp;})<br />&nbsp;&nbsp;&nbsp;&nbsp;post = await response.json()<br />&nbsp;&nbsp;}</p><p>&nbsp;&nbsp;return {<br />&nbsp;&nbsp;&nbsp;&nbsp;props: {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;post,<br />&nbsp;&nbsp;&nbsp;&nbsp;},<br />&nbsp;&nbsp;}</p>})</p></code></p><p>Notice that this function is wrapped with the function you created in kirill’s setup (which I renamed as <code>storeWrapper</code> instead of <code>wrapper</code> for clarity). The <code>store</code> this function receives is that <code>store</code> (which is the same one you imported in the previous function). The <code>params</code> variable comes from <code>getStaticPaths</code>.</p></li></ol><p>That’s pretty much it. You’ll set up your actions and reducers as normal for Redux with one exception: your actions must actually return the dispatched action objects, not just simply dispatch them. As you can see, setting up Redux with Nextjs takes a few extra tweaks, but it’s not too bad. Once you’re finished, the end result is quite amazing: pages rendered server side with a single source of truth for managing state in all your pages.</p><p>Happy coding!</p>",
  },
  {
    title: 'Debugging WTF',
    created_at: '2021-02-25',
    updated_at: '2021-02-25',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "<p> Debugging can often be one of the biggest four-letter words in software development. But it shouldn’t be. For one, debugging happens. Every project ever coded will need to be debugged, because every project ever coded will mess up in some way or another, at least once (usually multiple times). Also, debugging teaches you more about how your code actually works than all the tutorials and classes put together. For that reason, here are some tips to help make debugging a little smoother and hopefully more fun.</p><ol> <li> <p> READ every error message. Don’t just skim it, or say, “I have an error” then immediately ask for help or drop your code. Most error messages have a huge amount of information for you, and many are fairly straightforward. Sometimes they tell you exactly where in your code the issue lies. If not, then they usually tell you at least the ballpark area where your code failed, allowing you to zero in on it from there. </p> </li> <li> <p> Read the full stack trace. You may not want to do this every time, but at least every so often, you should read the full stack trace beginning to end. This helps you figure out the order in which the various pieces of your code are running, and the dependencies within that flow. Keep in mind that the actual failure point (your error) may be at either the top OR the bottom of the trace, depending on the language/framework you are using. </p> </li> <li> <p> Try to see if you can solve the issue by yourself before googling the answer or reaching out for help. Most people learn far more from their own mistakes than any other training experience. You’re a better coder than you think. If you understood the information #1 and #2 gave you even a little bit, then you probably have at least an idea of where to look to fix your code. Start there. Master Google-Fu. Whatever your favorite search engine, it is your best friend. If you can’t figure it out on your own, start searching for answers by copy/pasting the error message (just the error message, discerned in #1 above — don’t paste the entire stack). If you're fortunate, you may get results that exactly match your situation. Most likely, you will need to read posts and articles that kind of match what you’re facing, sometimes many of them. The more you understand what your code SHOULD be doing and what it is ACTUALLY doing, the more you can filter out the information that doesn’t apply and apply that which does. </p> </li> <li> <p> Ask. For. Help! This is not weakness or some symbol of failure as a developer/person/self-sufficient living organism. Identify the person or group of people most accessible to you who are most likely to answer the questions you have, explain your situation (politely and without complaining), and ask for insight. Then be open to the answers you receive. You may not like those answers. You may be told to completely rewrite your entire codebase. Accept it with a grain of salt, be gracious in your thanks, and again filter out the information that does not actually apply to your unique issue. </p> </li> <li> <p> Rinse and repeat. Continue cycling through steps 1–3 until you find the answers you are looking for. Don’t spend too much time on any one step. If you stop making progress on one step, move on to the next, or start the process over, somewhat differently. Search for different but related terms, ask different people, reread your code, etc. Go back to when your code worked (version control like Git makes this much simpler) and trace through it manually until you find what went wrong. </p> </li> <li> <p> Manage your emotions. Don’t snap at people trying to help you, even if they are completely wrong. Don’t berate yourself. You know what you are doing, and troubleshooting is a natural part of coding that all developers face. And if you get frustrated, walk away for a while. Go watch a movie, take a shower or a walk, play a game, something. Anything that is not actively looking at the problem. You’ll be amazed how often that will be the moment the solution comes to you. </p> </li></ol><p> The most important thing about debugging is your attitude. See the issue as a challenge that you will overcome, and that is exactly what you will do.</p><p> Happy coding! </p> <br />",
  },
  {
    title: 'Imposter Syndrome WTF',
    created_at: '2021-03-04',
    updated_at: '2021-03-04',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "<p> Imposter Syndrome is the name for the feeling of &quot;I don’t belong here; I’m not good enough&quot; that many of us know all too well. It can show up anywhere in anyone, but seems to be most often referenced within the Software world. However, it’s not unique to developers.</p><p> I am currently in the job-hunting phase of my transition into Software Development, yet I have still dealt with this feeling multiple times. Transitioning into the military I dealt with it. I wasn’t big or strong like my peers. I am not an alpha personality. Yet, I am capable of extraordinary stubbornness, and I continued on.</p><p> Each time I was transferred to a different area of responsibility within the military, I felt it. Yet, I believe I can learn (almost) anything quickly, so I continued on.</p><p> When I separated from the military into the entirely different world of Civilian and had to find a non-entry-level job for the first time, I felt it. But I had to provide for my family, so I pushed through the piles of applications and eventually landed a maintenance job.</p><p> At that job, when I worked alone for the first time, I felt it. But I had no one else to call on for help, so I figured things out on my own. Whether the solutions I came up with were the optimal ones or not, I found out later. But I still found those solutions even though I felt like I had no idea what I was looking at.</p><p> And even now, as I search for Software Development jobs, I have felt it. It got especially strong after I had been rejected by a few places and ignored by almost all the rest. I thought, &quot;I obviously don’t stand out; what am I doing wrong?&quot;</p><p> The answer frustrated me: Nothing. I was not doing anything wrong. I was checking all the boxes, reaching out to people, not companies, applying to the companies of everyone I reached out to, and doing this several times a day. So I started to think that maybe I’m not as good at coding as I thought. But I knew that was a lie. I am a very talented coder, even if I am inexperienced. All the feedback I got during school said as much and more.</p><p> So what was the real answer? My attitude. My belief that this process should be easier than it is, and that I was somehow insufficient because there are difficulties, *that* was what I was doing wrong.</p><p> So what is the solution? It’s simple (though simple and easy are not the same thing): believe in myself. Yes, that sounds like a fortune cookie, but it is true. Proverbs says that what we think in our hearts is who we are. Translation: you are who you believe you are. Are you good enough? Do you know enough? Can you handle this? If you believe yes, then yes. You may not know how yet, but you know you can. However, if you believe no, then no amount of help, training or practice will ever change the fact that you are not good enough, because you will always be only as good as you believe you are.</p><p> So, believe in yourself first. The how will come after you have settled that, and you will succeed at everything your hand touches.</p><p> Happy coding!</p><br />",
  },
  {
    title: 'Git WTF',
    created_at: '2021-03-11',
    updated_at: '2021-03-11',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "Git WTF <p> Git is, according to git-scm.org, &quot;a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.&quot; But what does that mean? And why should you know it as a coder?</p><p> To put it simply, git is what you use to both save and share your work. Think about it this way: you know how you always hear, &quot;Save often&quot;? Well, what does that really mean when coding? I mean, you have to save your work to even see the results of whatever changes you made anyway. And if you save junk code that breaks your project, then what? Rolling back to a previously saved version can be tough or even impossible, depending on your system.</p><p> So, what do you do? Manually go through your code and revert all the changes you made, one by one? On a small project where you have only made a few changes, that might work. But even a &quot;small&quot; project can quickly become too large to feasibly pull this off. Not to mention the massive amount of time you would waste in the process.</p><p> That’s where git (or any version control software) comes in. Essentially, it &quot;saves&quot; your record of saves for each file in your project, and allows you to revert all of them at once to whatever point in time you &quot;saved&quot; them (the real term is <strong>committed</strong>). For example, say you are working on a Next.js website, <code>/myapp</code>, and you decide to add a new page with a dynamically generated url, <code>/myapp/some_extra_feature</code>, with <code>some_extra_feature</code> being the dynamic part. You create the necessary extra files: <code>touch /pages/[some_extra_feature].js /styles/some_extra_feature.module.css</code>. You spend an hour writing and perfecting the code and layout, testing as you go, and you are very satisfied. With one final lookover of your newly-expanded project, you glance at the project requirements and realize: oh no. The dynamic url is supposed to look like <code>/myapp/some_extra_feature/this_is_the_dynamic_part</code>! What to do? Sure you could just create the <code>pages/some_extra_feature/</code> folder, rename <code>some_extra_feature.js</code>, rename <code>some_extra_feature.module.css</code>, change all your imports, and re-test the code, tweaking it line by line to verify it still performs the correct functions, but wouldn’t it be easier if you could just go back to the working model you had before you added this feature and start again? If you committed to git at that point, you can.</p><p> The other major use for git is the ability to share your work. Your commits are stored in what is called a repository. Git (and GitHub, which uses git) allows you to easily send a repository to a central storage place (like GitHub), provide the link/address to your partner/mentor/trainee/etc. and they can simply pull (more on this below) it to their machine and work with your code exactly as you committed it. Quick and easy!</p><p> To master git there are tons of commands you should learn. But you don’t need to master it to be able to reap these benefits I have mentioned. You only need a handful — the most common ones:</p><p> <code>git status</code> — this does what it says: it tells you the status of your repository (repo). It categorizes all the files of your repo into one of three categories: <em>will be committed</em>, <em>changes not committed</em>, and <em>untracked changes</em>. Anything categorized as <em>will be committed</em> will be &quot;saved&quot; as discussed above.</p><p> <code>git add</code> — allows you to re-categorize any files listed as <em>changes not committed</em> or <em>untracked changes</em> to <em>will be committed</em>.</p><p> <code>git commit</code> — actually performs the “save”</p><p> <code>git clone</code> — copy all files from a repo into a new repo on your local machine</p><p> <code>git pull</code> — get the current up-to-date version of the repo you cloned <strong>FROM</strong></p><p> <code>git push</code> — change the repo you pulled/cloned <strong>FROM</strong> into the current up-to-date version of the repo you cloned <strong>TO</strong></p><p> <code>git reset</code> — careful with this one, read the <a href='https://git-scm.com/docs/git-reset'>docs</a> about it. This allows you to cancel work you’ve done to return to a previous point in time. Again, BE CAREFUL, as careless usage of this can cost you hours of work.</p><p> There are many more commands for git. Once you are comfortable with these basic commands, I suggest you next learn about <code>git branch</code>, <code>git checkout</code>, and <code>git merge</code>. Trust me, by this point you will have a firm grasp on how to NOT lose your entire week’s work when your younger sister trips on your charging cable and simultaneously power cycles your laptop while pouring an entire smoothie into the cooling port.</p><p> Happy coding!</p><br />",
  },
  {
    title: 'Counting Sort WTF',
    created_at: '2021-03-18',
    updated_at: '2021-03-18',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "<p>In preparation for this weekend’s Kick Start Hackathon held by Google, I started going through last year’s questions. The very first one I came to gave me difficulty. Given a set budget amount and a list of house prices, calculate the maximum number of houses you can buy. The logic seemed simple enough, and I quickly had a solution worked out in Ruby.</p><p>The difficulty came with the speed requirement: no more than 15 seconds per test set. When you think in the realm of realism, that is plenty of time. Kick Start, however, never sticks to just &quot;realistic&quot; data sets. With a possible $100,000 to work with, house prices $1000 and below (wouldn’t that be nice!), and a possible 100,000 houses to choose from, the test sets get quite large. Large enough that the typical <strong>O(</strong><em>n log n</em><strong>)</strong> time complexity of Ruby’s built-in sort method times out and the answer fails.</p><p>After much Google-fu, I came across the counting sort. After much more, I found an explanation that didn’t require a Ph.D. in high-level mathematics to understand. Here is my attempt at re-explaining it in a much more vernacular style:</p><p>Let’s say you have an array: <code>arr = [1, 5, 3, 5, 2, 1]</code> that you need to sort. The first thing you need to do is count how many of each value you have, and match it to an index that corresponds to the value being counted.</p><p>We’ll start with an array with the same maximum index value as the maximum value found in <code>arr</code>, initialized to <code>0</code> for each value:</p><p><code>max_value = arr.max<br />counts = [0] * (max_value + 1)</code></p><p>Then we count each value in <code>arr</code> and set the value at the matching index in <code>counts</code> to that count:</p><p><code>arr.each {|val| counts[val] += 1}</code></p><p><code>counts</code> now equals <code>[0, 2, 1, 1, 0, 2]</code>. This translates to: &quot;The sorted array will have 0 zeroes, then 2 ones, then 1 two, then 1 three, then 0 fours, then 2 fives.&quot;</p><p>Now we use <code>counts</code> to re-factor <code>counts</code> on top of itself. The new version will hold values that match the number of values that precede that index value in the original arr. I’ll explain that better below:</p><p><code>num_items_before = 0<br />counts.each_with_index{|count, index|<br />&nbsp;&nbsp;counts[index] = num_items_before<br />&nbsp;&nbsp;num_items_before += count<br />}</code></p><p>This changes <code>counts</code> to <code>[0, 2, 3, 4, 4, 6]</code>. This translates to: &quot;fill up the sorted array with zeroes until before index 0 (which doesn’t exist, so 0 places), then fill with ones until before index 2 (two places), then fill with twos until before index 3 (one place), then fill with threes until before index 4 (one place), then fill with fours until before index 4 (same as before, so 0 places), then fill with fives until before index 6 (the end of the array, so 2 places)&quot;. This seems strange, but these extra steps prevent having to re-iterate through arr multiple times, saving time in exchange for the extra space needed for counts. Also, re-factoring counts on top of itself saves some additional space needed for a third array.</p><p>Finally, we create the sorted array from the new counts and return it:</p><p><code>sorted_array = [0] * arr.length<br />arr.each{|val|<br />&nbsp;&nbsp;sorted_array[counts[val]] = val<br />&nbsp;&nbsp;counts[val] -= 1<br />}</code></p><p>The decrementing of <code>counts[val]</code> allows for multiples of each value.</p><p>This returns <code>[1, 1, 2, 3, 5, 5]</code>. The best part is that this whole thing runs in <strong>O(</strong><em>n</em><strong>)</strong> time complexity and <strong>O(</strong><em>n</em><strong>)</strong> space complexity.</p><p>Happy coding!</p>",
  },
  {
    title: 'Next.js + Heroku WTF',
    created_at: '2021-03-22T02:18:19.080Z',
    updated_at: '2021-03-22T02:18:19.080Z',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "<p>After TWO WEEKS of R10 errors, I finally have my site up with my blog! Special thanks to Derik Linch for the answer!</p><p>It turns out, deploying a Next.js app to Heroku requires one simple modification, not covered ANYWHERE on Google. In your <code>package.json</code> file, NOT in a <code>Procfile</code> as the official website discusses, replace this line:</p><p><code>&quot;start&quot;: &quot;next start&quot;</code></p><p>with this one:</p><p><code>&quot;start&quot;: &quot;next start -p $PORT&quot;</code></p><p>THAT&#39;S IT! I am not sure why Heroku needs that slight modification (instead of it being built in), but I am ecstatic that it works! That&#39;s all this week.</p><p>Happy coding!</p>",
  },
  {
    title: 'Design vs Development WTF',
    created_at: '2021-04-02T04:40:14.240Z',
    updated_at: '2021-04-02T04:40:14.240Z',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "<p>This post is more of a rant than a how-to, so please bear with me.</p><p>I taught myself to code several years ago, and only last year attended a boot camp to get a more formal perspective. Through the whole process I have found a few issues with self-teaching. Number one on my mind right now is this:</p><p>For both designers and developers, there are essentially two levels of instruction to be found online: absolute noob and supreme master. Once a self-teacher has surpassed the basics, the next level of instruction usually involves in-depth dives into advanced topics, or costs several hundred dollars (or more). Essentially, the message becomes, &quot;you have completed the tutorial level. If you would like to continue, you must purchase the game. Note: free levels are awarded upon reaching level 1000.&quot;</p><p>So that I am not simply whining, I have decided upon a solution. I will provide a tutorial series for intermediate programmers and designers. I don&#39;t know when I will start this yet, because I have several higher-priority projects I&#39;m working on now, but I will do it. Keep watching, and I will notify you when the tutorial series is about to begin. (By the way, the tutorial will be totally free.)</p><p>Happy coding!</p>",
  },
  {
    title: 'TDD WTF',
    created_at: '2021-04-15T23:54:20.419Z',
    updated_at: '2021-04-15T23:54:20.419Z',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "<p>Test-Driven Development (TDD) is a very popular coding method currently. But what is TDD?</p><p>Essentially, it means that a coder first writes a test for an expected result, which fails immediately, then writes the minimum amount of code necessary to make the test pass. It seems backwards, but I recently dove into this style, and honestly, I love it.</p><p>Also known as the &quot;red-green-refactor&quot; method (because when the tests fail the results are usually displayed in red type and when they pass in green, so you see red first, then green, then you refactor the code as needed), this style actually helps keep your code minimal and efficient. This means less (or no) spaghetti code, and no dead code.</p><p>Starting can seem intimidating, though, especially for new coders. &quot;How can I know what to test for if I haven&#39;t written it yet?&quot; The trick to understanding this, though, is that you are not writing tests based on nothing. You write tests that look for the results you want your code to produce.</p><p>Then it&#39;s simply a matter of figuring out how to get there.</p><p>RSpec (for Ruby) is a great introduction to TDD, and I will cover that in my next post.</p><p>Happy coding!</p>",
  },
  {
    title: 'RSpec WTF',
    created_at: '2021-04-23T02:15:09.260Z',
    updated_at: '2021-04-23T02:15:09.260Z',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "<p>As I mentioned in my previous post, RSpec is a wonderful tool for learning Test-Driven Development (TDD). It should be noted that on RSpec&#39;s website, it refers to itself as a Behavior-Driven Development (BDD) tool. The difference between these two terms is slight, so for the purpose of this post, treat both as the same, and I will refer to both as TDD/BDD.</p><p>The first thing to know about RSpec is that it is a Ruby gem, so if you are using a different language, there are most likely multiple options for testing your specific language, but the principles should be the same. Because RSpec is a gem, it can be installed by simply running <code>gem install rspec</code> in your terminal or by adding <code>gem &#39;rspec&#39;</code> to your project&#39;s <code>Gemfile</code>, then running <code>bundle install</code>.</p><p>Once RSpec is installed, it&#39;s time to write your tests, or <strong>specs</strong> as RSpec calls them. These are usually stored in a <code>specs</code> folder in the root of your project. Split your specs up by functional area, and be sure that each spec filename ends with <code>_spec</code>. Don&#39;t worry; we&#39;ll go through a simple example now:</p><ol><li><p>Create a new folder called <code>rspec_example</code>. Inside it, create a file called <code>example.rb</code> and a file called <code>example_spec.rb</code>.</p></li><li><p>In <code>example_spec.rb</code> type the following:</p><p><code><p>require &#39;rspec&#39;</p><p>require_relative &#39;./example&#39;</p><p>RSpec.describe &#39;example&#39; do<br />&nbsp;&nbsp;it &quot;returns &#39;Hello, World!&#39;&quot; do<br />&nbsp;&nbsp;&nbsp;&nbsp;expect(hello_world()).to eq(&#39;Hello, World!&#39;)<br />&nbsp;&nbsp;end<br />end</p></code></p><p>What this means should be fairly self-explanatory, as RSpec is designed to almost mirror normal speech. The <code>eq</code> stands for &#39;equal&#39; and uses the <code>==</code> operator to compare the result of the method called inside <code>expect(hello_world())</code> with the value inside <code>eq(&#39;Hello, World!&#39;)</code>. If they are equal, the spec passes, and if not it fails.</p></li><li><p>Save and run <code>rspec example_spec.rb</code> from your console. It should fail with an error message: <code>NoMethodError: undefined method &#39;hello_world&#39; for #&lt;RSpec::ExampleGroups::Example:0x00000000022ae188&gt;</code> or something like it. This is good. This is saying that we have no method <code>hello_world</code> in <code>example.rb</code>, which we don&#39;t because we haven&#39;t created it. Let&#39;s do that now.</p></li><li><p>In <code>example.rb</code> create a method <code>hello_world</code> like so:</p><p><code>def hello_world<br />end</code></p><p>Don&#39;t worry about having it do anything yet. Just save and run <code>rspec example_spec.rb</code> again. Now we see this message:</p><p><code>F<br />Failures:<br />&nbsp;&nbsp;1) example returns &#39;Hello, World!&#39;<br />&nbsp;&nbsp;&nbsp;&nbsp;Failure/Error: expect(hello_world()).to eq(&#39;Hello, World!&#39;)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;expected: &quot;Hello, World!&quot;<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;got: nil<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(compared using ==)<br />&nbsp;&nbsp;&nbsp;&nbsp;# ./example_spec.rb:6:in `block (2 levels) in &lt;top (required)&gt;&#39;<br />Finished in 0.18145 seconds (files took 0.07452 seconds to load)<br />1 example, 1 failure<br />Failed examples:<br />rspec ./example_spec.rb:5 # example returns &#39;Hello, World!&#39;</code></p><p>This actually tells you a lot. The red <code>F</code> at the top tells you that one spec failed. We only wrote one spec, but if you had more, there would be a red <code>F</code> for each failure and a green <code>.</code> for each pass. The information after the <code>1)</code> tells you which spec failed, what was expected and what was actually received by the<code>expect</code>in our spec. We see that it expected to receive <code>&#39;Hello, World!&#39;</code> but actually received <code>nil</code>. We aren&#39;t returning anything from our method yet, so that makes sense. We need to write more.</p></li><li><p>Back in <code>example.rb</code> change <code>hello_world</code> to match the following:</p><p><code>def hello_world<br />&nbsp;&nbsp;&#39;Hello, World!&#39;<br />end</code></p><p>Then save and run <code>rspec example_spec.rb</code> one more time.</p><p>A green dot! And look, zero failures!</p></li></ol><p>Congratulations! You have written your first test using RSpec, and written it in a TDD/BDD way. Now go, read the docs and expand your ability to use this wonderful tool for your own projects.</p><p>Happy coding!</p>",
  },
  {
    title: '-ism WTF',
    created_at: '2021-06-22T17:19:50.015Z',
    updated_at: '2021-06-22T17:19:50.015Z',
    image_url: "https://picsum.photos/200?random=#{(Random.rand * 100).floor}",
    content: "<p>I apologize for not posting in a long time. Life has been rather overwhelming lately, but everything is moving forward smoothly once more.</p><p>I also apologize for the deviation in this post from my normal.</p><p>I wanted to address the various &quot;-isms&quot; that seem to run rampant in the world today: sexism, classism, racism, any fill-in-the-blank form of denegration, segregation and malice. In my opinion, they all come down to one thing, what I call the &#39;Us vs Them&#39; mentality,</p><p>i.e.:</p><p>&quot;They are Them and We are Us; Us is better than Them and will always be better, therefore Them do not have the same rights to respect, love, opportunities, or a generally good life as Us do, because Us will always reign Supreme.&quot;</p><p>In any situation, if one feels that they must justify their own existence and/or beliefs exclusively in contrast to another&#39;s, there is something fundamentally wrong with their viewpoint.</p><p>I am Me.<br />I have my own Beliefs, and my Existence within those Beliefs does not depend on You.<br />You have different Beliefs and a separate Existence.<br />There are things We disagree on.<br />There are things We agree on.<br />There are things I can learn from You.<br />There are things You can learn from Me.<br />Together, We can achieve far greater things than either of Us can alone.<br />Apart, one may rise, one may fall, both may rise, or both may fall. But the effect will never be as great as if both rise Together.</p><p><em>BTW all capitalization is for emphasis, in case it looks weird.</em></p>",
  },
]


BlogEntry.destroy_all

for entry in entries do
  entry[:content] = md.render(entry[:content]).gsub("\n", '<br />')

  BlogEntry.create!(entry)

  puts 'BlogEntry created!'
end

User.destroy_all

User.create!(username: 'admin', password: 'password', is_admin: true, email: 'admin@admin.com', image_url: 'https://picsum.photos/100')
