---
title: "Clojure Advent Of Code - a fun way to learn"
date: 2019-12-02
authors:
  - practicalli
categories:
  - clojure
tags:
  - code-challenge
---

![Practicalli Clojure Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/clojure-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

Advent of Code is the annual coding challenge with a festive theme.  Each day there is a new challenge in two parts, the first fairly easy the second a little more involved.  The challenges are an investment of your time to complete them all, although even trying just a few is enough to help you think in different ways.

Every programming language requires regular practice to maintain your skills.  A full time developer role gives you lots of opportunities to practice every day, however, its often focused in around solving problems within a specific business domain, with little time to explore others.  The Advent of Code puts you in a different domain, so its great for extending your coding experiences.

Solving challenges in a different language is another great way to extend your experiences, so here are some tips and examples for solving the advent of code in Clojure.

<!-- GitHub issue -->
<!-- https://github.com/practicalli/blog-content/issues/22 -->

<!-- more -->

## Tips

* Keep the solution as simple as possible.  Its very easy to over-complicate the solution and end up simply confusing yourself.

* Don't try and make the perfect solution.  Write something that works, this will give you a nice ego boost.  Then you can experiment with the code and see if you can improve your approach.

* Break down the problem into the simplest thing you can solve first.  Trying to solve a problem all at once will quickly have you going around in circles.

* Keep all the code and make notes.  I use a a design journal in my projects to document my thinking process, capture decisions that worked and those that didn't work for this project.  The journal is a great way to cement learning from solving the challenge.

* Challenges are only accessible from their day of the month onwards.  There is a count-down clock displayed on the next challenge to open, so you know when it will be available.  Don't feel pressured to keep up with the challenges though, enjoy the experience and have fun, you will learn more that way.

![Advent Of Code 2019 Day 1 challenge snippet](https://github.com/practicalli/graphic-design/blob/live/code-challenges/advent-of-code-2019-day1.png?raw=true)


## A previous example

In the following video I walk through the first challenge of Advent of Code from 2018, trying out different solutions at increasing levels of abstraction.  With each level of abstraction it helps to think in a more functional way.


<iframe width="560" height="315" src="https://www.youtube.com/embed/opM7fU7IAV8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## Creating a project

Create a directory that contains:

- `deps.edn` file containing an empty hash-map, `{}`
- `src/practicalli/advent_of_clojure_code/day-01.clj` file


Create a new Clojure file for each of the daily challenges.  It makes sense to keep both parts of each day in the same file.


## Useful Resources And Examples

Here are some videos of solving advent of code challenges and code solutions to many challenges from 2019 and past years.

* [fdlk/advent-2019](https://github.com/fdlk/advent-2019) - example Clojure solutions to the advent of code
* [Awesome Advent Of Code](https://github.com/Bogdanp/awesome-advent-of-code) - a collection of solutions in various languages
* [Advent of Code 2018 video walk-through of Clojure solutions by Tim Pote](https://potetm.com/videos.html) and [GitHub repository](https://github.com/potetm/advent-of-code)

Also take a look at the [#adventofcode channel in the Clojurians slack channel](https://clojurians.slack.com/messages/adventofcode).

---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button} 

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button} 
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
