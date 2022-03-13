package funkin.modding.module;

import funkin.modding.events.ScriptEventDispatcher;
import funkin.modding.events.ScriptEvent;
import funkin.modding.events.ScriptEvent.UpdateScriptEvent;

using funkin.util.IteratorTools;

/**
 * Utility functions for loading and manipulating active modules.
 */
class ModuleHandler
{
	static final moduleCache:Map<String, Module> = new Map<String, Module>();
	static var modulePriorityOrder:Array<String> = [];

	/**
	 * Parses and preloads the game's stage data and scripts when the game starts.
	 * 
	 * If you want to force stages to be reloaded, you can just call this function again.
	 */
	public static function loadModuleCache():Void
	{
		// Clear any stages that are cached if there were any.
		clearModuleCache();
		trace("[MODULEHANDLER] Loading module cache...");

		var scriptedModuleClassNames:Array<String> = ScriptedModule.listScriptClasses();
		trace('  Instantiating ${scriptedModuleClassNames.length} modules...');
		for (moduleCls in scriptedModuleClassNames)
		{
			var module:Module = ScriptedModule.init(moduleCls, moduleCls);
			if (module != null)
			{
				trace('    Loaded module: ${moduleCls}');

				// Then store it.
				addToModuleCache(module);
			}
			else
			{
				trace('    Failed to instantiate module: ${moduleCls}');
			}
		}
		reorderModuleCache();

		trace("[MODULEHANDLER] Module cache loaded.");
	}

	static function addToModuleCache(module:Module):Void
	{
		moduleCache.set(module.moduleId, module);
	}

	static function reorderModuleCache():Void
	{
		modulePriorityOrder = moduleCache.keys().array();

		modulePriorityOrder.sort(function(a:String, b:String):Int
		{
			var aModule:Module = moduleCache.get(a);
			var bModule:Module = moduleCache.get(b);

			if (aModule.priority != bModule.priority)
			{
				return aModule.priority - bModule.priority;
			}
			else
			{
				// Sort alphabetically. Yes that's how this works.
				return a > b ? 1 : -1;
			}
		});
	}

	public static function getModule(moduleId:String):Module
	{
		return moduleCache.get(moduleId);
	}

	public static function activateModule(moduleId:String):Void
	{
		var module:Module = getModule(moduleId);
		if (module != null)
		{
			module.active = true;
		}
	}

	public static function deactivateModule(moduleId:String):Void
	{
		var module:Module = getModule(moduleId);
		if (module != null)
		{
			module.active = false;
		}
	}

	public static function clearModuleCache():Void
	{
		if (moduleCache != null)
		{
			moduleCache.clear();
			modulePriorityOrder = [];
		}
	}

	public static function callEvent(event:ScriptEvent):Void
	{
		for (moduleId in modulePriorityOrder)
		{
			var module:Module = moduleCache.get(moduleId);
			// The module needs to be active to receive events.
			if (module != null && module.active)
			{
				ScriptEventDispatcher.callEvent(module, event);
			}
		}
	}
}
