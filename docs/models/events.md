---
title: Events
layout: post
menu_position: 2
---


# Event Model Documentation

## Overview

The Event model is a central component of our application. It is responsible for managing and storing all the information related to an event. This includes details about the event itself, settings related to the event, scheduling information, and more.

## Features

### Event Settings

The Event model includes a `store_accessor` for `event_settings`, which allows for the storage of key-value pairs in a single database column. This provides flexibility in storing various settings related to an event. The following settings are currently supported:

- `participant_label`: A string value that defaults to "speakers". This can be used to customize the label for participants in the event.
- `participant_description`: A string value that can be used to provide a description of the participants.
- `accept_sponsors`: A boolean value indicating whether the event accepts sponsors.
- `sponsors_label`: A string value that can be used to customize the label for sponsors.
- `sponsors_description`: A string value that can be used to provide a description of the sponsors.
- `public_streaming`: A boolean value indicating whether the event will be streamed publicly.
- `payment_gateway`: A string value indicating the payment gateway to be used for the event.
- `scheduling_label`: A string value that can be used to customize the label for the event's schedule.
- `scheduling_description`: A string value that can be used to provide a description of the event's schedule.
- `ticket_currency`: A string value indicating the currency to be used for the event's tickets.

### Event Scheduling

The Event model also includes scheduling information for the event. This includes the date and time of the event, as well as any other relevant scheduling details.

### Payment and Streaming

The Event model supports integration with various payment gateways and streaming services. The `payment_gateway` setting can be used to specify the payment gateway to be used for the event, while the `public_streaming` setting can be used to indicate whether the event will be streamed publicly.

### Scopes

The Event model includes several scopes for querying events based on their state or other attributes:

- `published`: Returns all events that are currently published.
- `drafts`: Returns all events that are currently in draft state.
- `managers`: Returns all events that are managed by an event manager.
- `public_events`: Returns all events that are published and not private.

## Conclusion

The Event model is a robust and flexible component of our application, providing a wide range of features for managing events. Whether you're scheduling an event, setting up payment and streaming services, or customizing event details, the Event model has you covered.