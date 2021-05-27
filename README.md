# Smart-Home-Simulation

## How to run

```
npm install http-server -g
```

```
http-server . -p 8000
```

## Message Protocol

Regarding the protocol that defines the structure of the messages exchanged between the Smart Home Simulator and the Mobile App, the following topics were defined.

### Lamp

In this category, we can do the following:

- STATE: change the state of a certain lamp. It takes one of the following values {"ON", "OFF"}.
- INT: change the intensity of a certain lamp. It takes one of the following values [0.5, 2.5].
- COLOR: change the color of a certain lamp. It takes any hex color.

```
message = {
  destinationName: "AmbInt/Lamp",
  payloadString: {
    "device_1" : {op: "STATE", value: "ON"}
    "device_2" : {op: "INT", value: 30}
    "device_3" : {op: "COLOR", value: "#ffffff"}
  }
}

{"Kitchen1" : {op: "STATE", value: "ON"}}

```

### Alarm

This category is the same as the previous one, where STATE can take one of the following values {"ON", "OFF"}.

```
message = {
  destinationName: "AmbInt/Alarm",
  payloadString: {
    "ALARM" : {op: "STATE", value: "ON"}
  }
}
```

### User

```
message = {
  destinationName: "AmbInt/Lamp",

  payloadString: {
    user: 'USERNAME',
    role: 'ADMIN | NORMAL'
  }
}
```

### Scenario

This category represents custom scenarios that the user can configure. The following example corresponds to a scenario where the lights are OFF and the alarm is ON

```
message = {
  destinationName: "AmbInt/Scenario",

  payloadString: {
    "Lamp" : [{"device_1" : {op: "STATE", value: "OFF"}}, {"device_2" : {op: "STATE", value: "OFF"}}],
    "Alarm" : {op: "STATE", value: "ON"}
  }
}
```

{"LAMP" : {Kitchen1 : {op: "STATE", value}}}
