package hex.compiler.factory;

import haxe.macro.Context;
import hex.ioc.vo.FactoryVO;
import hex.ioc.error.ParsingException;
import hex.ioc.vo.ConstructorVO;
import hex.util.MacroUtil;

/**
 * ...
 * @author Francis Bourre
 */
class XmlFactory
{
	function new()
	{

	}

	#if macro
	static public function build( factoryVO : FactoryVO ) : Dynamic
	{
		var constructorVO 	= factoryVO.constructorVO;
		var args 			= constructorVO.arguments;
		var factory 		= constructorVO.factory;

		if ( args != null ||  args.length > 0 )
		{
			var source : String = args[ 0 ].arguments[ 0 ];
			
			if ( source.length > 0 )
			{
				if ( factory == null )
				{
					if ( !constructorVO.isProperty )
					{
						var idVar = constructorVO.ID;
						factoryVO.expressions.push( macro @:pos( constructorVO.filePosition ) @:mergeBlock { var $idVar = Xml.parse( $v { source } ); } );
					}
				}
				else
				{
					if ( !constructorVO.isProperty )
					{
						var idVar = constructorVO.ID;
						var typePath = null;
						
						typePath = MacroUtil.getTypePath( factory, constructorVO.filePosition );

						var parser = "factory_" + constructorVO.ID;
						factoryVO.expressions.push( macro @:pos( constructorVO.filePosition ) @:mergeBlock { var $parser = new $typePath(); } );
						
						var parserVar = macro $i{ parser };
						factoryVO.expressions.push( macro @:pos( constructorVO.filePosition ) @:mergeBlock { var $idVar = $parserVar.parse( Xml.parse( $v { source } ) ); } );
					}
				}
			}
			else
			{
				#if debug
				trace( "XmlFactory.build() returns an empty XML." );
				#end
				
				var idVar = constructorVO.ID;
				factoryVO.expressions.push( macro @:mergeBlock { var $idVar = Xml.parse( "" ); } );
			}
		}
		else
		{
			#if debug
			trace( "XmlFactory.build() returns an empty XML." );
			#end

			var idVar = constructorVO.ID;
			factoryVO.expressions.push( macro @:mergeBlock { var $idVar = Xml.parse( "" ); } );
		}
		
		return null;
	}
	#end
}