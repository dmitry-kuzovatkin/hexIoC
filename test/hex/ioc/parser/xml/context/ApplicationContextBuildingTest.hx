package hex.ioc.parser.xml.context;

import hex.domain.ApplicationDomainDispatcher;
import hex.ioc.assembler.ApplicationAssembler;
import hex.ioc.assembler.ApplicationContext;
import hex.ioc.core.IContextFactory;
import hex.ioc.parser.xml.context.mock.MockApplicationContext;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class ApplicationContextBuildingTest
{
	var _contextParser 				: ApplicationXMLParser;
	var _applicationAssembler 		: ApplicationAssembler;
		
	@Before
	public function setUp() : Void
	{
		this._applicationAssembler 	= new ApplicationAssembler();
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
	
	@Test( "test applicationContext building" )
	public function testApplicationContextBuilding() : Void
	{
		this.build( XmlReader.readXmlFile( "context/applicationContextBuildingTest.xml" ) );
		
		var builderFactory : IContextFactory = this._applicationAssembler.getContextFactory( this._applicationAssembler.getApplicationContext( "applicationContext" ) );
		
		var applicationContext : ApplicationContext = builderFactory.getCoreFactory().locate( "applicationContext" );
		Assert.isNotNull( applicationContext, "applicationContext shouldn't be null" );
		Assert.isInstanceOf( applicationContext, MockApplicationContext, "applicationContext should be an instance of 'MockApplicationContext'" );
		Assert.equals( "Hola Mundo", builderFactory.getCoreFactory().locate( "test" ), "String values should be the same" );
	}
}