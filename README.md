# hexIoC

[![TravisCI Build Status](https://travis-ci.org/DoclerLabs/hexIoC.svg?branch=master)](https://travis-ci.org/DoclerLabs/hexIoC)
Inversion of Control system with DSL and modularity based on global and micro contexts.

*Find more information about hexMachina on [hexmachina.org](http://hexmachina.org/)*

## Dependencies

* [hexCore](https://github.com/DoclerLabs/hexCore)
* [hexAnnotation](https://github.com/DoclerLabs/hexAnnotation)
* [hexInject](https://github.com/DoclerLabs/hexInject)
* [hexMVC](https://github.com/DoclerLabs/hexMVC)
* [hexState](https://github.com/DoclerLabs/hexState)
* [hexService](https://github.com/DoclerLabs/hexService)


## Full example for parsing/building application context
```haxe
var applicationAssembler = new ApplicationAssembler();
var xml = Xml.parse( XmlReader.readXmlFile( "example.xml" ) );
var parser = new ApplicationXMLParser();
parser.parse( applicationAssembler, xml );
applicationAssembler.buildEverything();
```

## Simple example
```xml
<root name="applicationContext">
	<test id="s" value="hello"/>
</root>
```

## Building dynamic object
```xml
<root name="applicationContext">
	<test id="obj" type="Object">
		<property name="name" value="Francis"/>
		<property name="age" type="Int" value="44"/>
		<property name="height" type="Float" value="1.75"/>
		<property name="isWorking" type="Bool" value="true"/>
	</test>
</root>
```

## Passing arguments to constructor
```xml
<root name="applicationContext">
	<bean id="size" type="hex.structures.Size">
		<argument type="Int" value="10"/>
		<argument type="Int" value="20"/>
	</bean>
</root>
```

## Injection by using references 
```xml
<root name="applicationContext">
	<rectangle id="rect" type="hex.ioc.parser.xml.mock.MockRectangle">
		<argument ref="rectPosition.x"/>
		<argument ref="rectPosition.y"/>
		<property name="size" ref="rectSize" />
	</rectangle>
	
	<size id="rectSize" type="hex.structures.Point">
		<argument type="Int" value="30"/>
		<argument type="Int" value="40"/>
	</size>
	
	<position id="rectPosition" type="hex.structures.Point">
		<property type="Int" name="x" value="10"/>
		<property type="Int" name="y" value="20"/>
	</position>
</root>
```

## Injection and method call
```xml
<root name="applicationContext">
	<rectangle id="rect" type="hex.ioc.parser.xml.mock.MockRectangle">
		<property name="size" ref="rectSize" />
		<method-call name="offsetPoint">
			<argument ref="rectPosition"/>
		</method-call></rectangle>
	
	<size id="rectSize" type="hex.structures.Point">
		<argument type="Int" value="30"/>
		<argument type="Int" value="40"/>
	</size>
	
	<position id="rectPosition" type="hex.structures.Point">
		<property type="Int" name="x" value="10"/>
		<property type="Int" name="y" value="20"/>
	</position>
	
	<rectangle id="anotherRect" type="hex.ioc.parser.xml.mock.MockRectangle">
		<property name="size" ref="rectSize" />
		<method-call name="reset"/>
	</rectangle>
</root>
```

## Singleton instantiation
```xml
<root name="applicationContext">
	<gateway id="gateway" value="http://localhost/amfphp/gateway.php"/>
	
	<service id="service" type="hex.ioc.parser.xml.mock.MockServiceProvider" singleton-access="getInstance">
		<method-call name="setGateway">
			<argument ref="gateway" />
		</method-call>
	</service>
</root>
```

## Factory instantiation
```xml
<root name="applicationContext">
	<rectangle id="rect" type="hex.ioc.parser.xml.mock.MockRectangleFactory" factory="getRectangle">
		<argument type="Int" value="10"/><argument type="Int" value="20"/>
		<argument type="Int" value="30"/><argument type="Int" value="40"/>
	</rectangle>
</root>
```

## Factory instantiation using singleton
```xml
<root name="applicationContext">
	<point id="point" type="hex.ioc.parser.xml.mock.MockPointFactory" singleton-access="getInstance" factory="getPoint">
		<argument type="Int" value="10"/>
		<argument type="Int" value="20"/>
	</point>
</root>
```

## XML type parsed
```xml
<root name="applicationContext">
	<data id="fruits" type="XML" parser-class="hex.ioc.parser.xml.mock.MockXMLParser">
		<root>
			<node>orange</node>
			<node>apple</node>
			<node>banana</node>
		</root>
	</data>
</root>
```

## Array containing references
```xml
<root name="applicationContext">
	<collection id="fruits" type="Array">
		<argument ref="fruit0" />
		<argument ref="fruit1" />
		<argument ref="fruit2" />
	</collection>

	<fruit id="fruit0" type="hex.ioc.parser.xml.mock.MockFruitVO"><argument value="orange"/></fruit>
	<fruit id="fruit1" type="hex.ioc.parser.xml.mock.MockFruitVO"><argument value="apple"/></fruit>
	<fruit id="fruit2" type="hex.ioc.parser.xml.mock.MockFruitVO"><argument value="banana"/></fruit>
</root>
```

## Building an HashMap
```xml
<root name="applicationContext">
	<collection id="fruits" type="hex.core.HashMap">
		<item> <key value="0"/> <value ref="fruit0"/></item>
		<item> <key type="Int" value="1"/> <value ref="fruit1"/></item>
		<item> <key ref="stubKey"/> <value ref="fruit2"/></item>
	</collection>

	<fruit id="fruit0" type="hex.ioc.parser.xml.mock.MockFruitVO"><argument value="orange"/></fruit>
	<fruit id="fruit1" type="hex.ioc.parser.xml.mock.MockFruitVO"><argument value="apple"/></fruit>
	<fruit id="fruit2" type="hex.ioc.parser.xml.mock.MockFruitVO"><argument value="banana"/></fruit>

	<point id="stubKey" type="hex.structures.Point"/>
</root>
```

## Module listening another module
```xml
<root name="applicationContext">
	<chat id="chat" type="hex.ioc.parser.xml.mock.MockChatModule">
		<listen ref="translation"/>
	</chat>

	<translation id="translation" type="hex.ioc.parser.xml.mock.MockTranslationModule">
		<listen ref="chat">
			<event static-ref="hex.ioc.parser.xml.mock.MockChatModule.TEXT_INPUT" method="onSomethingToTranslate"/>
		</listen>
	</translation>
</root>
```

## Module listening another module with adapter strategy
```xml
<root name="applicationContext">
	<chat id="chat" type="hex.ioc.parser.xml.mock.MockChatModule">
		<listen ref="translation"/>
	</chat>

	<translation id="translation" type="hex.ioc.parser.xml.mock.MockTranslationModule">
		<listen ref="chat">
			<event static-ref="hex.ioc.parser.xml.mock.MockChatModule.TEXT_INPUT" method="onTranslateWithTime" strategy="hex.ioc.parser.xml.mock.MockChatAdapterStrategy"/>
		</listen>
	</translation>
</root>
```

## Class reference
```xml
<root name="applicationContext">
	<RectangleClass id="RectangleClass" type="Class" value="hex.ioc.parser.xml.mock.MockRectangle"/>
	
	<test id="classContainer" type="Object">
		<property name="AnotherRectangleClass" ref="RectangleClass"/>
	</test>
</root>
```

## Building a service locator
```xml
<root name="applicationContext">
	<serviceLocator id="serviceLocator" type="hex.config.stateful.ServiceLocator">
		<item> <key type="Class" value="hex.ioc.parser.xml.mock.IMockFacebookService"/> <value ref="facebookService"/></item>
	</serviceLocator>
</root>
```

## Building a mapping configuration with mapped service classes
```xml
<root name="applicationContext">
	<config id="config" type="hex.ioc.di.MappingConfiguration">
		<item map-name="amazon0"> <key type="Class" value="hex.ioc.parser.xml.mock.IMockAmazonService"/> <value type="Class" value="hex.ioc.parser.xml.mock.MockAmazonService"/></item>
		<item map-name="amazon1"> <key type="Class" value="hex.ioc.parser.xml.mock.IMockAmazonService"/> <value type="Class" value="hex.ioc.parser.xml.mock.AnotherMockAmazonService"/></item>
	</config>
</root>
```

## Module listening a service
```xml
<root name="applicationContext">
	<service id="myService" type="hex.ioc.parser.xml.mock.MockStubStatefulService"/>

	<module id="myModule" type="hex.ioc.parser.xml.mock.MockModuleWithServiceCallback">
		<listen ref="myService">
			<event static-ref="hex.ioc.parser.xml.mock.MockStubStatefulService.BOOLEAN_VO_UPDATE" method="onBooleanServiceCallback"/>
		</listen>
	</module>
</root>
```

## State machine configuration
```xml
<root name="applicationContext">
	<initialState id="initialState" static-ref="hex.ioc.parser.xml.state.mock.MockStateEnum.INITIAL_STATE">
		<method-call name="addTransition">
			<argument static-ref="hex.ioc.parser.xml.state.mock.MockStateMessage.TRIGGER_NEXT_STATE"/>
			<argument static-ref="hex.ioc.parser.xml.state.mock.MockStateEnum.NEXT_STATE"/>
		</method-call>

		<method-call name="addExitCommand">
			<argument type="Class" value="hex.ioc.parser.xml.state.mock.MockExitStateCommand"/>
			<argument ref="myModule"/>
		</method-call>

	</initialState>

	<stateConfig id="stateConfig" type="hex.state.config.stateful.StatefulStateMachineConfig">
		<argument ref="initialState"/>
	</stateConfig>

	<module id="myModule" type="hex.ioc.parser.xml.state.mock.MockModuleWorkingWithStates">
		<argument ref="stateConfig"/>
	</module>
</root>
```

## Module listening service with adapter strategy and module injections
```xml
<root name="applicationContext">
	<service id="myService" type="hex.ioc.parser.xml.mock.MockStubStatefulService"/>

	<module id="myModule" type="hex.ioc.parser.xml.mock.MockModuleWithServiceCallback">
		<listen ref="myService">
			<event static-ref="hex.ioc.parser.xml.mock.MockStubStatefulService.INT_VO_UPDATE"
				   method="onFloatServiceCallback"
				   strategy="hex.ioc.parser.xml.mock.MockIntDividerEventAdapterStrategy"
				   injectedInModule="true"/>
		</listen>
	</module>
</root>
```

## Redefining application context class
```xml
<root name="applicationContext" type="hex.ioc.parser.xml.context.mock.MockApplicationContext">
	<test id="test" value="Hola Mundo"/>
</root>
```

## Listening application context states changes
```xml
<root name="applicationContext">
	<state id="assemblingStart" ref="applicationContext.state.ASSEMBLING_START">
		<enter command-class="hex.ioc.parser.xml.assembler.mock.MockStateCommand"/>
	</state>
	
	<state id="objectsBuilt" ref="applicationContext.state.OBJECTS_BUILT">
		<enter command-class="hex.ioc.parser.xml.assembler.mock.MockStateCommandWithModule" fire-once="true" context-owner="module"/>
	</state>
	
	<state id="domainListenersAssigned" ref="applicationContext.state.DOMAIN_LISTENERS_ASSIGNED">
		<enter command-class="hex.ioc.parser.xml.assembler.mock.MockStateCommand"/>
	</state>
	
	<state id="methodsCalled" ref="applicationContext.state.METHODS_CALLED">
		<enter command-class="hex.ioc.parser.xml.assembler.mock.MockStateCommand"/>
	</state>
	
	<state id="modulesInitialized" ref="applicationContext.state.MODULES_INITIALIZED">
		<enter command-class="hex.ioc.parser.xml.assembler.mock.MockStateCommand"/>
	</state>
	
	<state id="assemblingEnd" ref="applicationContext.state.ASSEMBLING_END">
		<enter command-class="hex.ioc.parser.xml.assembler.mock.MockStateCommandWithModule" fire-once="true" context-owner="anotherModule"/>
	</state>
	
	<module id="module" type="hex.ioc.parser.xml.assembler.mock.MockModule" map-type="hex.module.IModule"/>
	<module id="anotherModule" type="hex.ioc.parser.xml.assembler.mock.MockModule" map-type="hex.module.IModule"/>
</root>
```

## Conditional parsing
```haxe
<root name="applicationContext">
	<msg id="message" value="hello debug" if="debug,release"/>
	<msg id="message" value="hello production" if="production"/>
</root>
```
```haxe
applicationAssembler.addConditionalProperty ( ["production" => true, "debug" => false, "release" => false] );
```

## Preprocessing
```xml
<root ${context}>
	${node}
</root>
```
```haxe
var preprocessor = new Preprocessor();
preprocessor.addProperty( "hello", "bonjour" );
preprocessor.addProperty( "contextName", 'applicationContext' );
preprocessor.addProperty( "context", 'name="$${contextName}"' );
preprocessor.addProperty( "node", '<msg id="message" value="$${hello}"/>' );
```

## Include
```xml
<?xml version="1.0" encoding="utf-8" ?>
<root name="applicationContext">
	<include file="../bin/otherContext.xml"/>
	<include file="lib/anotherContext.xml"/>
</root>
```

## Read xml at compile time with preprocessing
```haxe
var xml = Xml.parse( XmlReader.readXmlFile( "../context/preprocessor.xml", 
[	
	"hello" 		=> "bonjour",
	"contextName" 	=> 'applicationContext',
	"context" 		=> 'name="${contextName}"',
	"node" 			=> '<msg id="message" value="${hello}"/>' 
] ) );
```
