package hex.ioc.parser.xml.state;

import hex.domain.ApplicationDomainDispatcher;
import hex.ioc.assembler.ApplicationAssembler;
import hex.ioc.core.IContextFactory;
import hex.ioc.parser.xml.ApplicationXMLParser;
import hex.ioc.parser.xml.state.mock.MockModuleWorkingWithStates;
import hex.ioc.parser.xml.state.mock.MockStateEnum;
import hex.state.State;
import hex.state.config.stateful.StatefulStateMachineConfig;
import hex.unittest.assertion.Assert;


/**
 * ...
 * @author Francis Bourre
 */
class StatefulStateMachineConfigTest
{
	var _contextParser 				: ApplicationXMLParser;
	var _builderFactory 			: IContextFactory;
	var _applicationAssembler 		: ApplicationAssembler;
		
	@Before
	public function setUp() : Void
	{
		this._applicationAssembler 	= new ApplicationAssembler();
		this._builderFactory 		= this._applicationAssembler.getContextFactory( this._applicationAssembler.getApplicationContext( "applicationContext" ) );
	}

	@After
	public function tearDown() : Void
	{
		ApplicationDomainDispatcher.getInstance().clear();
		this._applicationAssembler.release();
	}
	
	function build( xml : String ) : Void
	{
		this._contextParser = new ApplicationXMLParser();
		this._contextParser.parse( this._applicationAssembler, Xml.parse( xml ) );
		this._applicationAssembler.buildEverything();
	}
	
	@Test( "test statemachine configuration" )
	public function testStateMachineConfiguration() : Void
	{
		this.build( XmlReader.readXmlFile( "context/statefulStateMachineConfigTest.xml" ) );

		var initialState : State = this._builderFactory.getCoreFactory().locate( "initialState" );
		Assert.isNotNull( initialState, "state should not be null" );
		Assert.equals( MockStateEnum.INITIAL_STATE, initialState, "state should be the same" );

		var stateConfig : StatefulStateMachineConfig = this._builderFactory.getCoreFactory().locate( "stateConfig" );
		Assert.isNotNull( stateConfig, "config should not be null" );

		var myModule : MockModuleWorkingWithStates = this._builderFactory.getCoreFactory().locate( "myModule" );
		Assert.isNotNull( myModule, "module should not be null" );

		Assert.isTrue( myModule.commandWasCalled, "command should be called" );
	}
}