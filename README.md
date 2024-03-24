# AudioFilms

### The Origins

Well over a decade ago, I was road-tripping somewhere with Brandon, one my oldest and dearest friends, and he brought along his portable DVD player. Cool. You might not know this, but Brandon was a big DVD guy back then. He eventually shifted to Blu-ray when it made sense, but in recent years he dipped a toe into VHS before taking a **hard** turn toward LaserDisc. Double cool.

Anyhoo, so I'm road-tripping with Brandon and his portable DVD player. He starts popping DVDs into that thing and sends the audio straight to aux on the car stereo! We had it *made*. More often than not I was the one driving, with my eyes on the road, just listening to the movies that Brandon was watching. I was having a great time.

After toying with the idea for a couple years, I finally purchased the domain way back in 2014 (a literal decade ago), wired up a simple Ruby on Rails, and got the first 20 or so films into the catalogue. It was fun, but also kinda boring. Turns out that part of the project, adding to the catalogue, was a bit too cumbersome and didn't really excite me. Things grew stale, eventually [the hosting provider eliminated their free option](https://help.heroku.com/RSBRUH58/removal-of-heroku-free-product-plans-faq), and I wasn't about to pay a monthly fee for this silly idea.

Fast-forward another 10 years and I have been inspired yet again! It's time to get this thing back online and really build up the catalogue.

With the latest and greatest in [GitHub Pages](https://pages.github.com) and [Jekyll](https://jekyllrb.com), I am able to recreate what I once and make it better, easier, etc. New titles will get added weekly-ish, and please [send a request](mailto:request@audiofilms.net?subject=I%27ve%20got%20an%20idea%20for%20an%20AudioFilm) if you don't see your favorite movies on the list!

[audiofilms.net](https://audiofilms.net)

### The Technology

Overall this is a pretty simple and straightforward Jekyll GitHub Pages site with a few little ruby scripts to help automate a few things.

The `/_films` directory is where you will find the *film* markdown files. They contain only front matter with all the necessary metadata for each film. As of this writing, that includes:

```
tmdb-id:
layout:
added:
released:
slug:
permalink:
title:
description:
```

All of that metadata (along with the movie poster) comes directly from [The Movie Database (TMDB)](https://www.themoviedb.org) with the help of [themoviedb ruby gem](https://github.com/ahmetabdi/themoviedb). I manually search for the movie I want to import, grab the `tmdb-id` (my naming convention) , and use that to run `/rb/import.rb`. That script grabs the metadata, creates the markdown file, and populates the metadata. Pretty straightforward.

There's also a `/rb/refresh.rb` script that is pretty similar, but instead it loops through each film file, parses the current YAML content, and then repopulates it with whatever large-scale change that I need. That way I can easily change the format or rename one of metadata keys across all film files. It's great.

Also, I had to [fork the slugify gem](https://github.com/eliduke/Slugify) because I had very specific sluggification needs, namely that I wanted a slightly different mapping of certain characters, as you can see here:

[SCREENSHOT]

I wrapped all that up in `/rb/sluggit.rb` where I got even more specific about my sluggification needs because I don't want movie titles to start with "The" or "A" and throw off the sorting of things. In those instances, the actual metadata title is correct and contains all the words of the movie title, but the file name / slug / permalink don't include it so that it sits correctly in the list of all the other films.

All film posters and audios are hosted with [bunny.net](https://bunny.net), a super duper simple and inexpensive storage / CDN service that I have really come to love. For simple projects, is sooooo much easier than S3. Highly recommend.
