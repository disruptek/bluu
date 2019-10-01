
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApplicationInsightsManagementClient
## version: 2015-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Application Insights client for web test based alerting.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_596458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596458): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "applicationinsights-webTests_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_WebTestsList_596680 = ref object of OpenApiRestCall_596458
proc url_WebTestsList_596682(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/webtests")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebTestsList_596681(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all Application Insights web test alerts definitions within a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_596842 = path.getOrDefault("subscriptionId")
  valid_596842 = validateParameter(valid_596842, JString, required = true,
                                 default = nil)
  if valid_596842 != nil:
    section.add "subscriptionId", valid_596842
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596843 = query.getOrDefault("api-version")
  valid_596843 = validateParameter(valid_596843, JString, required = true,
                                 default = nil)
  if valid_596843 != nil:
    section.add "api-version", valid_596843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596870: Call_WebTestsList_596680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Application Insights web test alerts definitions within a subscription.
  ## 
  let valid = call_596870.validator(path, query, header, formData, body)
  let scheme = call_596870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596870.url(scheme.get, call_596870.host, call_596870.base,
                         call_596870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596870, url, valid)

proc call*(call_596941: Call_WebTestsList_596680; apiVersion: string;
          subscriptionId: string): Recallable =
  ## webTestsList
  ## Get all Application Insights web test alerts definitions within a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_596942 = newJObject()
  var query_596944 = newJObject()
  add(query_596944, "api-version", newJString(apiVersion))
  add(path_596942, "subscriptionId", newJString(subscriptionId))
  result = call_596941.call(path_596942, query_596944, nil, nil, nil)

var webTestsList* = Call_WebTestsList_596680(name: "webTestsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Insights/webtests",
    validator: validate_WebTestsList_596681, base: "", url: url_WebTestsList_596682,
    schemes: {Scheme.Https})
type
  Call_WebTestsListByComponent_596983 = ref object of OpenApiRestCall_596458
proc url_WebTestsListByComponent_596985(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "componentName" in path, "`componentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "componentName"),
               (kind: ConstantSegment, value: "/webtests")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebTestsListByComponent_596984(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all Application Insights web tests defined for the specified component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   componentName: JString (required)
  ##                : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596995 = path.getOrDefault("resourceGroupName")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "resourceGroupName", valid_596995
  var valid_596996 = path.getOrDefault("subscriptionId")
  valid_596996 = validateParameter(valid_596996, JString, required = true,
                                 default = nil)
  if valid_596996 != nil:
    section.add "subscriptionId", valid_596996
  var valid_596997 = path.getOrDefault("componentName")
  valid_596997 = validateParameter(valid_596997, JString, required = true,
                                 default = nil)
  if valid_596997 != nil:
    section.add "componentName", valid_596997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596998 = query.getOrDefault("api-version")
  valid_596998 = validateParameter(valid_596998, JString, required = true,
                                 default = nil)
  if valid_596998 != nil:
    section.add "api-version", valid_596998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596999: Call_WebTestsListByComponent_596983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Application Insights web tests defined for the specified component.
  ## 
  let valid = call_596999.validator(path, query, header, formData, body)
  let scheme = call_596999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596999.url(scheme.get, call_596999.host, call_596999.base,
                         call_596999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596999, url, valid)

proc call*(call_597000: Call_WebTestsListByComponent_596983;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          componentName: string): Recallable =
  ## webTestsListByComponent
  ## Get all Application Insights web tests defined for the specified component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   componentName: string (required)
  ##                : The name of the Application Insights component resource.
  var path_597001 = newJObject()
  var query_597002 = newJObject()
  add(path_597001, "resourceGroupName", newJString(resourceGroupName))
  add(query_597002, "api-version", newJString(apiVersion))
  add(path_597001, "subscriptionId", newJString(subscriptionId))
  add(path_597001, "componentName", newJString(componentName))
  result = call_597000.call(path_597001, query_597002, nil, nil, nil)

var webTestsListByComponent* = Call_WebTestsListByComponent_596983(
    name: "webTestsListByComponent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{componentName}/webtests",
    validator: validate_WebTestsListByComponent_596984, base: "",
    url: url_WebTestsListByComponent_596985, schemes: {Scheme.Https})
type
  Call_WebTestsListByResourceGroup_597003 = ref object of OpenApiRestCall_596458
proc url_WebTestsListByResourceGroup_597005(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/webtests")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebTestsListByResourceGroup_597004(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all Application Insights web tests defined within a specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597006 = path.getOrDefault("resourceGroupName")
  valid_597006 = validateParameter(valid_597006, JString, required = true,
                                 default = nil)
  if valid_597006 != nil:
    section.add "resourceGroupName", valid_597006
  var valid_597007 = path.getOrDefault("subscriptionId")
  valid_597007 = validateParameter(valid_597007, JString, required = true,
                                 default = nil)
  if valid_597007 != nil:
    section.add "subscriptionId", valid_597007
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597008 = query.getOrDefault("api-version")
  valid_597008 = validateParameter(valid_597008, JString, required = true,
                                 default = nil)
  if valid_597008 != nil:
    section.add "api-version", valid_597008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597009: Call_WebTestsListByResourceGroup_597003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Application Insights web tests defined within a specified resource group.
  ## 
  let valid = call_597009.validator(path, query, header, formData, body)
  let scheme = call_597009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597009.url(scheme.get, call_597009.host, call_597009.base,
                         call_597009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597009, url, valid)

proc call*(call_597010: Call_WebTestsListByResourceGroup_597003;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## webTestsListByResourceGroup
  ## Get all Application Insights web tests defined within a specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_597011 = newJObject()
  var query_597012 = newJObject()
  add(path_597011, "resourceGroupName", newJString(resourceGroupName))
  add(query_597012, "api-version", newJString(apiVersion))
  add(path_597011, "subscriptionId", newJString(subscriptionId))
  result = call_597010.call(path_597011, query_597012, nil, nil, nil)

var webTestsListByResourceGroup* = Call_WebTestsListByResourceGroup_597003(
    name: "webTestsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/webtests",
    validator: validate_WebTestsListByResourceGroup_597004, base: "",
    url: url_WebTestsListByResourceGroup_597005, schemes: {Scheme.Https})
type
  Call_WebTestsCreateOrUpdate_597024 = ref object of OpenApiRestCall_596458
proc url_WebTestsCreateOrUpdate_597026(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "webTestName" in path, "`webTestName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/webtests/"),
               (kind: VariableSegment, value: "webTestName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebTestsCreateOrUpdate_597025(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an Application Insights web test definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   webTestName: JString (required)
  ##              : The name of the Application Insights webtest resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597044 = path.getOrDefault("resourceGroupName")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "resourceGroupName", valid_597044
  var valid_597045 = path.getOrDefault("webTestName")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "webTestName", valid_597045
  var valid_597046 = path.getOrDefault("subscriptionId")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "subscriptionId", valid_597046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597047 = query.getOrDefault("api-version")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "api-version", valid_597047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   WebTestDefinition: JObject (required)
  ##                    : Properties that need to be specified to create or update an Application Insights web test definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597049: Call_WebTestsCreateOrUpdate_597024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an Application Insights web test definition.
  ## 
  let valid = call_597049.validator(path, query, header, formData, body)
  let scheme = call_597049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597049.url(scheme.get, call_597049.host, call_597049.base,
                         call_597049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597049, url, valid)

proc call*(call_597050: Call_WebTestsCreateOrUpdate_597024;
          resourceGroupName: string; apiVersion: string; webTestName: string;
          subscriptionId: string; WebTestDefinition: JsonNode): Recallable =
  ## webTestsCreateOrUpdate
  ## Creates or updates an Application Insights web test definition.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   webTestName: string (required)
  ##              : The name of the Application Insights webtest resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   WebTestDefinition: JObject (required)
  ##                    : Properties that need to be specified to create or update an Application Insights web test definition.
  var path_597051 = newJObject()
  var query_597052 = newJObject()
  var body_597053 = newJObject()
  add(path_597051, "resourceGroupName", newJString(resourceGroupName))
  add(query_597052, "api-version", newJString(apiVersion))
  add(path_597051, "webTestName", newJString(webTestName))
  add(path_597051, "subscriptionId", newJString(subscriptionId))
  if WebTestDefinition != nil:
    body_597053 = WebTestDefinition
  result = call_597050.call(path_597051, query_597052, nil, nil, body_597053)

var webTestsCreateOrUpdate* = Call_WebTestsCreateOrUpdate_597024(
    name: "webTestsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/webtests/{webTestName}",
    validator: validate_WebTestsCreateOrUpdate_597025, base: "",
    url: url_WebTestsCreateOrUpdate_597026, schemes: {Scheme.Https})
type
  Call_WebTestsGet_597013 = ref object of OpenApiRestCall_596458
proc url_WebTestsGet_597015(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "webTestName" in path, "`webTestName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/webtests/"),
               (kind: VariableSegment, value: "webTestName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebTestsGet_597014(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific Application Insights web test definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   webTestName: JString (required)
  ##              : The name of the Application Insights webtest resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597016 = path.getOrDefault("resourceGroupName")
  valid_597016 = validateParameter(valid_597016, JString, required = true,
                                 default = nil)
  if valid_597016 != nil:
    section.add "resourceGroupName", valid_597016
  var valid_597017 = path.getOrDefault("webTestName")
  valid_597017 = validateParameter(valid_597017, JString, required = true,
                                 default = nil)
  if valid_597017 != nil:
    section.add "webTestName", valid_597017
  var valid_597018 = path.getOrDefault("subscriptionId")
  valid_597018 = validateParameter(valid_597018, JString, required = true,
                                 default = nil)
  if valid_597018 != nil:
    section.add "subscriptionId", valid_597018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597019 = query.getOrDefault("api-version")
  valid_597019 = validateParameter(valid_597019, JString, required = true,
                                 default = nil)
  if valid_597019 != nil:
    section.add "api-version", valid_597019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597020: Call_WebTestsGet_597013; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific Application Insights web test definition.
  ## 
  let valid = call_597020.validator(path, query, header, formData, body)
  let scheme = call_597020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597020.url(scheme.get, call_597020.host, call_597020.base,
                         call_597020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597020, url, valid)

proc call*(call_597021: Call_WebTestsGet_597013; resourceGroupName: string;
          apiVersion: string; webTestName: string; subscriptionId: string): Recallable =
  ## webTestsGet
  ## Get a specific Application Insights web test definition.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   webTestName: string (required)
  ##              : The name of the Application Insights webtest resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_597022 = newJObject()
  var query_597023 = newJObject()
  add(path_597022, "resourceGroupName", newJString(resourceGroupName))
  add(query_597023, "api-version", newJString(apiVersion))
  add(path_597022, "webTestName", newJString(webTestName))
  add(path_597022, "subscriptionId", newJString(subscriptionId))
  result = call_597021.call(path_597022, query_597023, nil, nil, nil)

var webTestsGet* = Call_WebTestsGet_597013(name: "webTestsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/webtests/{webTestName}",
                                        validator: validate_WebTestsGet_597014,
                                        base: "", url: url_WebTestsGet_597015,
                                        schemes: {Scheme.Https})
type
  Call_WebTestsUpdateTags_597065 = ref object of OpenApiRestCall_596458
proc url_WebTestsUpdateTags_597067(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "webTestName" in path, "`webTestName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/webtests/"),
               (kind: VariableSegment, value: "webTestName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebTestsUpdateTags_597066(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates or updates an Application Insights web test definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   webTestName: JString (required)
  ##              : The name of the Application Insights webtest resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597068 = path.getOrDefault("resourceGroupName")
  valid_597068 = validateParameter(valid_597068, JString, required = true,
                                 default = nil)
  if valid_597068 != nil:
    section.add "resourceGroupName", valid_597068
  var valid_597069 = path.getOrDefault("webTestName")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = nil)
  if valid_597069 != nil:
    section.add "webTestName", valid_597069
  var valid_597070 = path.getOrDefault("subscriptionId")
  valid_597070 = validateParameter(valid_597070, JString, required = true,
                                 default = nil)
  if valid_597070 != nil:
    section.add "subscriptionId", valid_597070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597071 = query.getOrDefault("api-version")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = nil)
  if valid_597071 != nil:
    section.add "api-version", valid_597071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   WebTestTags: JObject (required)
  ##              : Updated tag information to set into the web test instance.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597073: Call_WebTestsUpdateTags_597065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an Application Insights web test definition.
  ## 
  let valid = call_597073.validator(path, query, header, formData, body)
  let scheme = call_597073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597073.url(scheme.get, call_597073.host, call_597073.base,
                         call_597073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597073, url, valid)

proc call*(call_597074: Call_WebTestsUpdateTags_597065; resourceGroupName: string;
          apiVersion: string; webTestName: string; subscriptionId: string;
          WebTestTags: JsonNode): Recallable =
  ## webTestsUpdateTags
  ## Creates or updates an Application Insights web test definition.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   webTestName: string (required)
  ##              : The name of the Application Insights webtest resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   WebTestTags: JObject (required)
  ##              : Updated tag information to set into the web test instance.
  var path_597075 = newJObject()
  var query_597076 = newJObject()
  var body_597077 = newJObject()
  add(path_597075, "resourceGroupName", newJString(resourceGroupName))
  add(query_597076, "api-version", newJString(apiVersion))
  add(path_597075, "webTestName", newJString(webTestName))
  add(path_597075, "subscriptionId", newJString(subscriptionId))
  if WebTestTags != nil:
    body_597077 = WebTestTags
  result = call_597074.call(path_597075, query_597076, nil, nil, body_597077)

var webTestsUpdateTags* = Call_WebTestsUpdateTags_597065(
    name: "webTestsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/webtests/{webTestName}",
    validator: validate_WebTestsUpdateTags_597066, base: "",
    url: url_WebTestsUpdateTags_597067, schemes: {Scheme.Https})
type
  Call_WebTestsDelete_597054 = ref object of OpenApiRestCall_596458
proc url_WebTestsDelete_597056(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "webTestName" in path, "`webTestName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/webtests/"),
               (kind: VariableSegment, value: "webTestName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebTestsDelete_597055(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an Application Insights web test.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   webTestName: JString (required)
  ##              : The name of the Application Insights webtest resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597057 = path.getOrDefault("resourceGroupName")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "resourceGroupName", valid_597057
  var valid_597058 = path.getOrDefault("webTestName")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "webTestName", valid_597058
  var valid_597059 = path.getOrDefault("subscriptionId")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "subscriptionId", valid_597059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597060 = query.getOrDefault("api-version")
  valid_597060 = validateParameter(valid_597060, JString, required = true,
                                 default = nil)
  if valid_597060 != nil:
    section.add "api-version", valid_597060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597061: Call_WebTestsDelete_597054; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Application Insights web test.
  ## 
  let valid = call_597061.validator(path, query, header, formData, body)
  let scheme = call_597061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597061.url(scheme.get, call_597061.host, call_597061.base,
                         call_597061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597061, url, valid)

proc call*(call_597062: Call_WebTestsDelete_597054; resourceGroupName: string;
          apiVersion: string; webTestName: string; subscriptionId: string): Recallable =
  ## webTestsDelete
  ## Deletes an Application Insights web test.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   webTestName: string (required)
  ##              : The name of the Application Insights webtest resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_597063 = newJObject()
  var query_597064 = newJObject()
  add(path_597063, "resourceGroupName", newJString(resourceGroupName))
  add(query_597064, "api-version", newJString(apiVersion))
  add(path_597063, "webTestName", newJString(webTestName))
  add(path_597063, "subscriptionId", newJString(subscriptionId))
  result = call_597062.call(path_597063, query_597064, nil, nil, nil)

var webTestsDelete* = Call_WebTestsDelete_597054(name: "webTestsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/webtests/{webTestName}",
    validator: validate_WebTestsDelete_597055, base: "", url: url_WebTestsDelete_597056,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
