---
section: "Projections"
version: "4.0.0"
pinned: true
---

# Overview

## What are projections?

Projections is a subsystem in Event Store that provides you with the ability to write new or link existing events to streams in a reactive manner.

> [!NOTE]
> Projections require the event body to be in JSON.

## When to use projections?

Projections are good at solving one specific query type, a category known as 'temporal correlation queries'. This query type happens more often than you may think in business systems and few systems can execute these queries well.

## Business Cases

You are looking for how many users on Twitter said "happy" within 5 minutes of the word "foo coffee shop" and within 2 minutes of saying "london".

While a simple example,  this is the type of query that projections can solve. Let's try a real business problem.

As a medical research doctor you want to find people that were diagnosed with pancreatic cancer within the last year. During their treatment they should not have had any proxies for a heart condition such as aspirin given every morning. Within three weeks of their diagnosis they should have been put on treatment X. Within one month after starting the treatment they should have failed with a lab result that looks like L1. Within another six weeks they should have been been put on treatment Y and within four weeks failed that treatment with a lab result that looks like L2.

This is a common type of query that exists in many industries and is the exact case that projections work well as a query model for.

You can use projections in nearly all examples of near real-time complex event processing. There are a large number of problems that fit into this category from monitoring of temperature sensors in a data centre to reacting to changes in the stock market.

It is important to remember the types of problems that projections are intended to solve. Many problems are not a good fit with the projections library and will be better served by hosting another read model that is populated by a catchup subscription

## Continuous Querying

Projections also support the concept of continuous queries. When running a projection you can choose whether the query should run and give you all results present or whether the query should continue running into the future finding new results as they happen and updating its result set.

As an example in the medical example above the doctor could leave the query running and be notified of any new patients that happened to meet the criteria that they was searching for. The output of all queries is a stream, this stream can then be listened to like any other stream.

<!-- TODO: Is this supposed to be here? -->

## Types of Projections

There are 2 types of projections, there are built in (system) projections which are written in C# and then there are javascript projections which you can create via the API or the admin UI.
