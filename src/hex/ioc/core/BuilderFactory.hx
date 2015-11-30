package hex.ioc.core;

import haxe.ds.HashMap;
import hex.domain.IApplicationDomainDispatcher;
import hex.ioc.control.BuildArrayCommand;
import hex.ioc.control.BuildBooleanCommand;
import hex.ioc.control.BuildClassCommand;
import hex.ioc.control.BuildFloatCommand;
import hex.ioc.control.BuildFunctionCommand;
import hex.ioc.control.BuildInstanceCommand;
import hex.ioc.control.BuildIntCommand;
import hex.ioc.control.BuildNullCommand;
import hex.ioc.control.BuildStringCommand;
import hex.ioc.control.IBuildCommand;
import hex.ioc.locator.ConstructorVOLocator;
import hex.ioc.locator.MethodCallVOLocator;
import hex.ioc.locator.PropertyVOLocator;
import hex.ioc.vo.BuildHelperVO;
import hex.ioc.vo.ConstructorVO;

/**
 * ...
 * @author Francis Bourre
 */
class BuilderFactory
{
	private var _moduleLocator				: ModuleLocator;
	private var _applicationContext 		: ApplicationContext;
	private var _commandMap 				: HashMap<String, Class<IBuildCommand>>;
	private var _coreFactory 				: CoreFactory;
	private var _applicationDomainHub 		: IApplicationDomainDispatcher;
	private var _IDExpert 					: IDExpert;
	private var _constructorVOLocator 		: ConstructorVOLocator;
	private var _propertyVOLocator 			: PropertyVOLocator;
	private var _methodCallVOLocator 		: MethodCallVOLocator;
	private var _domainListenerVOLocator 	: DomainListenerVOLocator;
	//private var _displayObjectBuilder 		: DisplayObjectBuilder;

	public function BuilderFactory( applicationContext : ApplicationContext, moduleLocator : ModuleLocator )
	{
		this._moduleLocator = moduleLocator;
		this.init( applicationContext );
	}

	public function getApplicationContext() : ApplicationContext
	{
		return this._applicationContext;
	}

	public function getCoreFactory() : CoreFactory
	{
		return this._coreFactory;
	}

	public function getApplicationHub() : IApplicationDomainDispatcher
	{
		return this._applicationDomainHub;
	}

	public function getIDExpert() : IDExpert
	{
		return this._IDExpert;
	}

	public function getConstructorVOLocator() : ConstructorVOLocator
	{
		return this._constructorVOLocator;
	}

	public function getPropertyVOLocator() : PropertyVOLocator
	{
		return this._propertyVOLocator;
	}

	public function getMethodCallVOLocator() : MethodCallVOLocator
	{
		return this._methodCallVOLocator;
	}

	public function getDomainListenerVOLocator() : DomainListenerVOLocator
	{
		return this._domainListenerVOLocator;
	}

	public function getDisplayObjectBuilder() : DisplayObjectBuilder
	{
		return this._displayObjectBuilder;
	}

	public function init( applicationContext : ApplicationContext ) : void
	{
		this._applicationContext 		= applicationContext;
		this._commandMap 				= new HashMap( String, Class<IBuildCommand> );
		this._coreFactory 				= new CoreFactory();
		this._applicationDomainHub 		= ApplicationDomainHub.getInstance();
		this._IDExpert 					= new IDExpert();
		this._constructorVOLocator 		= new ConstructorVOLocator( this );
		this._propertyVOLocator 		= new PropertyVOLocator( this );
		this._methodCallVOLocator 		= new MethodCallVOLocator( this );
		this._domainListenerVOLocator 	= new DomainListenerVOLocator( this );
		//this._displayObjectBuilder 		= new DisplayObjectBuilder( applicationContext.getRootTarget(), this._coreFactory );

		this._coreFactory.addListener( this._propertyVOLocator );

		this.addType( ContextTypeList.ARRAY, BuildArrayCommand );
		this.addType( ContextTypeList.BOOLEAN, BuildBooleanCommand );
		this.addType( ContextTypeList.INSTANCE, BuildInstanceCommand );
		this.addType( ContextTypeList.INT, BuildIntCommand );
		this.addType( ContextTypeList.NULL, BuildNullCommand );
		this.addType( ContextTypeList.NUMBER, BuildFloatCommand );
		this.addType( ContextTypeList.OBJECT, BuildObjectCommand );
		this.addType( ContextTypeList.STRING, BuildStringCommand );
		this.addType( ContextTypeList.UINT, BuildUIntCommand );
		this.addType( ContextTypeList.DEFAULT, BuildStringCommand );
		this.addType( ContextTypeList.DICTIONARY, BuildDictionaryCommand );
		this.addType( ContextTypeList.SERVICECONFIG, BuildServiceConfigCommand );
		this.addType( ContextTypeList.CLASS, BuildClassCommand );
		this.addType( ContextTypeList.XML, BuildXMLCommand );
		this.addType( ContextTypeList.FUNCTION, BuildFunctionCommand );
		this.addType( ContextTypeList.UNKNOWN, BuildInstanceCommand );
	}

	public function addType( type : String, build : Class<IBuildCommand> ) : Void
	{
		this._commandMap.put( type, build );
	}

	public function build( constructorVO : ConstructorVO, ?id : String ) : Dynamic
	{
		var type : String = constructorVO.type;
		var commandClass : Class<IBuildCommand> = ( this._commandMap.containsKey( type ) ) ? this._commandMap.get( type ) : this._commandMap.get( ContextTypeList.INSTANCE );
		var buildCommand : IBuildCommand = Type.createInstance( commandClass, [] );

		var builderHelperVO:BuildHelperVO 		= new BuildHelperVO();
		builderHelperVO.type 					= type;
		builderHelperVO.builderFactory 			= this;
		builderHelperVO.coreFactory 			= this._coreFactory;
		builderHelperVO.constructorVO 			= constructorVO;
		builderHelperVO.moduleLocator 			= this._moduleLocator;

		buildCommand.setHelper( builderHelperVO );
		buildCommand.execute();

		if ( id )
		{
			this._coreFactory.register( id, constructorVO.result );
		}

		return constructorVO.result;
	}

	public function release() : Void
	{
		this._coreFactory.removeListener( this._propertyVOLocator );
		this._coreFactory.clear();

		this._constructorVOLocator.release();
		this._propertyVOLocator.release();
		this._methodCallVOLocator.release();
		this._domainListenerVOLocator.release();
		this._commandMap.clear();

		this._IDExpert.clear();
	}
}