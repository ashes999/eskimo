## eskimo
Eskimo is an entity-component system written in haxe, focused on having a small codebase, and functionality over performance.

##### Previous Efforts:
* hxE - lacked functionality, as a system could only process 1 type of Entity by default.
* hxE2 - had functionality, but was inconsistent, messy codebase due to a bad design choice, and because of this was hard to maintain or debug.

##### API Overview
* `Context` - entry point to using eskimo.
  * `.create():Entity` - creates and returns a new `Entity`.
  * `.destroy(entity):Void` - destroys the passed `Entity`.
* `Entity`
  * `.set(myComponent):Void` - set an object of any class to this `Entity`.
  * `.get(MyComponentClass):MyComponentClass` - get a component of this `Entity` by class.
  * `.remove(MyComponentClass):Void` - remove a component of this `Entity` by class.
  * `.has(MyComponentClass):Bool` - check if this `Entity` has a component type.
* `View([IncludeComponents..], ?[ExcludeComponents..], ?context)` - maintains a list of `Entity` objects corresponding to the `IncludeComponents` and `ExcludeComponents` criteria.
  * `.entities:Array<Entity>` - an array of entities currently meeting the criteria of this `View`.
* `EventView([IncludeComponents..], ?[ExcludeComponents..], ?context)` - extends `View` with entity changes.
  * `.added:Array<Entity>` - an array of added entities to this `View`.
  * `.updated:Array<Entity>` - an array of updated entities.
  * `.removed:Array<Entity>` - an array of removed entities.
  * `.clear():Void` - clears `added`/`updated`/`removed` arrays.
* `BufferView([IncludeComponents..], ?[ExcludeComponents..], ?context)` - extends `View` with a component buffer.
  * `.previous(entity, MyComponentClass):MyComponentClass` - previous component of the passed `Entity` as buffered by this `BufferView`.
  * `.buffer():Void` - buffers the current components of all entities in this `View`.

##### Overview
Eskimo is currently focused on single-threaded execution. hxE2 attempted to address this, but with overkill; every single View would be threadsafe, which is unnecessary (multiple systems running on 1 thread, multiple views in a single system, etc.)

Another problem addressed by Eskimo is the entry point to modifying entity components. Although probably less efficient, it is much clearer than hxE2. Setting and getting components *always* happens through the Entity instance itself, not through a `View`. In the future I'll add more performant methods in accessing components, but the concept will be the same - always directly setting/getting to/from the ComponentManager. This means that under the hood, event management becomes simpler and consistent, with views still able to control which events they process.

Components no longer have a base class, and can be any object at all. Systems also are defined only by the `ISystem` interface. Like hxE2, using the provided systems and the SystemManager class to run them is completely optional, and considered a utility more than anything else. In the future, I am working on helper macros to save users from tedious house keeping, so that you can get right to coding system logic.

Views have a better defined role in eskimo than in hxE2 - at the core they *only* manage a list of entities that correspond to its filters. Previous iterations would have Views managing local component storage which only bloated things. I will add several types of views, starting with a basic "state" view, that only manages a list of entities, an "event" view, that will also manage a list of added/updated/removed entities, and a "buffer" view, that will store the previous component state of entities.

Phew. Any questions, make an issue. I'll work on a few samples and a short code demo right here in the description, meanwhile there's already a sample demonstrating the basic functionality. I'll be using this for my own projects and will update as I find things/add things.

##### License
MIT as in free. Use it as you wish. Hopefully ethically and morally.