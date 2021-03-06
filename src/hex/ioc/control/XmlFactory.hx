package hex.ioc.control;

import hex.data.IParser;
import hex.ioc.error.ParsingException;
import hex.ioc.vo.FactoryVO;

/**
 * ...
 * @author Francis Bourre
 */
class XmlFactory
{
	function new()
	{

	}

	static public function build( factoryVO : FactoryVO ) : Void
	{
		var constructorVO 	= factoryVO.constructorVO;
		var args 			= constructorVO.arguments;
		var factory 		= constructorVO.factory;

		if ( args != null ||  args.length > 0 )
		{
			#if macro
			var source : String = args[ 0 ].arguments[ 0 ];
			#else
			var source : String = args[ 0 ];
			#end
			
			if ( source.length > 0 )
			{
				if ( factory == null )
				{
					constructorVO.result = Xml.parse( source );
				}
				else
				{
					try
					{
						var parser : IParser<Dynamic> = factoryVO.coreFactory.buildInstance( factory );
						constructorVO.result = parser.parse( Xml.parse( source ) );
					}
					catch ( error : Dynamic )
					{
						throw new ParsingException( "XmlFactory.build() failed to deserialize XML with '" + factory + "' deserializer class." );
					}
				}
			}
			else
			{
				#if debug
				trace( "XmlFactory.build() returns an empty XML." );
				#end

				constructorVO.result = Xml.parse( "" );
			}
		}
		else
		{
			#if debug
			trace( "XmlFactory.build() returns an empty XML." );
			#end

			constructorVO.result = Xml.parse( "" );
		}
	}
}