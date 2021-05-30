<p align="center">
<a href="https://github.com/BBorombo/lazx/actions"><img src="https://github.com/BBorombo/lazx/workflows/Build/badge.svg" alt="build"></a>
<a href="https://codecov.io/gh/BBorombo/lazx"><img src="https://codecov.io/gh/BBorombo/lazx/branch/main/graph/badge.svg" alt="codecov"></a>
<a href="https://github.com/BBorombo/lazx"><img src="https://img.shields.io/github/stars/BBorombo/lazx.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://www.buymeacoffee.com/borombo" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="25px"></a>
</p>

# Lazx

A state management library based on the ViewModel design pattern for Flutter.  
From a lazy dev for lazy devs. 🥱

## Index
- [Introduction](#introduction)
- [Usage](#Usage)
- [Examples](#examples)
- [Motivation](#motivation)
- [Contributing](#contributing)
- [Articles & Videos](#articles-and-videos)
- [Dart Version](#dart-version)
- [Maintainers](#maintainers)
- [FAQ](#faq)

## Introduction
Lazx is a state-management library that makes it easy to handle reactive data, from your UI without having to think about how you will do it.

It's based on the **MVVM design pattern** and allows you to implement it in the easiest way possible.

You will not have to *handle many files, inherit many classes or think about the best way to implement it*, everything is done in a way that you just have to think about the logic and UI of your app, nothing more (and nothing less, I can't make your app for you 🤷‍♂️).

Enough talking let's jump into the concrete things 👇

## Usage
Lazx can be used in many ways and has been made so it can be adapted depending the situation you're facing. 

Everything is based around the use of the Lazx Widgets/Builders but before, you should understand the easy concept of... **MVVM applied with Lazx**.

### MVVM with Lazx
#### Intro : Lazx State
Everything is about state in Flutter  which is not necessarly the case in other languages/platforms. For these reason, I've added the **managment of state inside the data** so it can be synced with the state of your views. 

I've determined **4 main states** :

 - **Initial** - Represent the default state for a data. Could be before a loading/success/error flow, or just the one default state. By default, every data/view will starts with this state.
 - **Loading** - Represent a loading state for the data, if applicable.
 - **Success** - Represent a success state for a data. Could also be for a loaded data.
 - **Error** - Represent an error state for a data, if applicable.

#### The Model : Lazx Data 
For those comming from the Android world a LazxData is a simple version of [LiveData](https://developer.android.com/topic/libraries/architecture/livedata) adapter to Flutter with a state managment. 

For the other, it's a way to subscribe and listen to the changes of your data and introduce a state to it. 
```dart
// Initialize your data 
LazxData<int> counter = LazxData<int>(0);

// Access the current value 
final currentValue = counter.value;

// Update the value/state 
counter.push(counter.value + 1);
counter.push(-1, lxState: LxState.Error);
counter.setState(LxState.Loading);

// Listen to value/state changes 
counter.stream.listen((value) {  
  print(value);  
});

counter.state.listen((state) {  
  print(state);  
});
```

`LazxData` are made to be used inside view models 👇

#### Lazx View Model - The View Model

A view model is simply a class that will be **linked to a view and hold its data**. 
A `LazxViewModel` is exactly that, with the addition that your data are `LazxData` objects and you should declare them. 

> You can totally use a LazxViewModel wihtout using LazxData's.

```dart
class SimpleDemoViewModel extends LazxViewModel {  
  LazxData<int> counter = LazxData<int>(0);  
  
  @override  
  List<LazxData> get props => [counter];  
  
 void increment() {  
    counter.push(counter.value + 1);  
  }  
}
```
The `props` getter is used to dispose all your `LazxData` listeners when the view model is disposed... at the same time that the view it's linked to.

The view model should be linked to a view, the Lazx Screen 👇 

#### Lazx ~~Screen~~ View  - The View
The view will be **linked to only one view model**. 
I've called a view ~~LazxScreen~~ `LazxView` as usually, a there's a view model per screen, so you should use the `LazxView` on a widget that represent a screen for your app. 

> Of course, you can totally use a `LazxView` for a portion of your screen (also known as Fragment in Android) 

```dart
class LxDemoScreen extends LazxScreen<SimpleDemoViewModel> {  
  @override  
  SimpleDemoViewModel getViewModel() => SimpleDemoViewModel();  
  
  @override  
  Widget build(BuildContext context, SimpleDemoViewModel viewModel) {  
    return Scaffold(  
      backgroundColor: Colors.white,  
	  appBar: AppBar(  
        title: Text('Lazx Screen Demo'),  
	  ),  
	  body: Center(  
        child: Text('Too Lazx'),   
	  ),  
	);  
  }  
}
```
The function `getViewModel()` should be overrided to provide the view model of your screen. The viewModel will then be linked to your screen view.

The build function will be a bit different en give you access directly to your view Model. 

You can of course access your view model in other Widgets down in the tree of you `LazxScreen` by using : 

```dart
// Access view model from any widget down in the sub tree  
viewModel<SimpleDemoViewModel>(context).doSomething();
```
### Lazx Widgets & Builders
Let's see how you can use your data/view model in your different widgets. 

#### Lazx Builder
The easiest one, the `LazxBuilder` allows you to build a widget each time the value of your `LazxData` is updated.
> ⚠️ The state is not used with this builder

```dart
LazxBuilder<int>(  
  data: viewModel.counter,  
  builder: (context, value) {  
    return Text('$value');  
  }
),
```
You should pass a `LazxData` as the data and the builder will be called each time with the updated value.

#### Lazx State Builder
The `LazxStateBuilder` is almost the same that the previous one but it takes the state of your data into consideration. 

You will be able to have a "builder" function for each state : 
```dart
LazxStateBuilder<int>(  
  data: viewModel.counter,  
  initial: (context, value) {  
    return Text('$value');  
  },  
  loading: (context, value) {  
    return CircularProgressIndicator();  
  },  
  success: (context, value) {  
    return Text(
      '$value',
      style: TextStyle(color: Colors.green),
    );  
  }
),
```
You have a builder function with the name of each state. Only the `initial` one if mandatory, you can implement the other ones only if needed. 

They will be called each time the state of your data is updated.

#### Lazx State Widget & Data Builder
From the previous builder, instead of having all the builder function for a state inside a builder (that could become long to write in one place if there's a lot of differences) you can have them directly inside a widget : 

```dart 
class LxCounterText extends LazxStateWidget {  
  @override  
  Widget initial(BuildContext context, data) {  
    return Text('$data');  
  }  
  
  @override  
  Widget loading(BuildContext context, data) {  
    return CircularProgressIndicator();  
  }  
  
  @override  
  Widget success(BuildContext context, data) {  
    return Text(  
      '$data',  
      style: TextStyle(color: Colors.green),
	);  
  }  
}
```
The same as for the builder, you don't have to override all the function, only the `initial` one is required.

Then you cand use a `LazxDataBuilder` wich is simplier : 

```dart 
LazxDataBuilder(  
  data: viewModel.counter,  
  lxWidget: LxCounterText(),  
),
```
The behavior is the same than with the `LazxStateBuilder`.

Check the examples for more concrete usages 👇 

## Examples
- [Demo App](https://github.com/borombo-git/lazx/tree/main/examples/demo) - A simple demo of all the Lazx Widgets/Builders

## Motivation

So... Why **Lazx** ?

I'm originally an Android Developer and I learned and practiced Flutter and really enjoyed it. 💙

The thing is that **I'm really lazy** and when it comes to make a good and strong architecture for your app in Flutter, it becomes a bit complicated and too greedy in ressources.

Depending on what you like (BloC, Redux, Provider...) you will have to create multiple files, handle multiples things, and I felt like I had to make **a whole logic and organization, just for the architecture and state management of my app**. 🤯

So after having done a few production apps with Flutter, I was really lazy to again, having to setup everything about architecture and state management.

In the other side, I had a really smooth structure for my apps in native Android development and really used to use it. As the other solutions in Flutter didn't really fit my needs and I couldn't find enough resources to use them at their fullest potential I finally decided to do the thing that every lazy person would do : **Make my own state management**. 🧐

That's how **Lazx** is born (with this fantastic and long searched name) 🐣

## Contributing
_Want to contribute to the project? Here are some points where you can contribute :_

- Report bugs and scenarios that are difficult to implement
- Report parts of the documentation that are unclear
- Update the documentation / add examples
- Implement new features/tests by making a pull-request
- Adding documentation to the readme .
- Write articles or make videos teaching how to use Lazx (they will be inserted in the Readme).

Any contribution is welcomed!

## Articles and Videos
Coming soon. 🎬

## Dart Version
- Dart 2: >= 2.12

## Maintainers
- [Borombo](https://github.com/BBorombo)
