package eskimo.views;
import eskimo.ComponentManager.ComponentType;
import eskimo.Entity;
import eskimo.containers.Container;
import eskimo.filters.IFilter;
import eskimo.views.View;

/**
 * ...
 * @author PDeveloper
 */

interface IBufferContainer
{
	public function buffer(e:Entity):Void;
}

class BufferContainer<T> implements IBufferContainer
{
	
	public var container:Container<T>;
	
	private var array:Array<T>;
	
	public function new(container:Container<T>):Void
	{
		this.container = container;
		
		array = new Array<T>();
	}
	
	public function buffer(e:Entity):Void
	{
		array[e.id] = container.get(e);
	}
	
	public function get(e:Entity):T
	{
		return array[e.id];
	}
	
}

class BufferView extends View
{
	
	private var map:Map<String, Int>;
	
	private var currentBuffers:Array<IBufferContainer>;
	private var previousBuffers:Array<IBufferContainer>;
	
	public function new(filter:IFilter, ?_entities:EntityManager = null):Void
	{
		map = new Map<String, Int>();
		
		currentBuffers = new Array<IBufferContainer>();
		previousBuffers = new Array<IBufferContainer>();
		
		for (index in 0...includes.length)
		{
			var include = includes[index];
			map.set(Type.getClassName(include), index);
			
			var container = _entities.components.getContainer(include);
			
			var currentBuffer = new BufferContainer(container);
			var previousBuffer = new BufferContainer(container);
			
			currentBuffers.push(currentBuffer);
			previousBuffers.push(previousBuffer);
		}
		
		super(filter, _entities);
		
		for (e in entities) for (b in previousBuffers) b.buffer(e);
	}
	
	override public function update(e:Entity, index:Int):Void 
	{
		currentBuffers[index].buffer(e);
		
		super.update(e, index);
	}
	
	public function previous<T>(e:Entity, componentClass:Class<T>):T
	{
		var className = Type.getClassName(componentClass);
		if (map.exists(className))
		{
			var index = map.get(className);
			var buffer:BufferContainer<T> = cast previousBuffers[index];
			
			return buffer.get(e);
		}
		else return null;
	}
	
	public function buffer():Void
	{
		var buffer = previousBuffers;
		previousBuffers = currentBuffers;
		currentBuffers = buffer;
	}
	
}