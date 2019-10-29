
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "applicationinsights-webTests_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_WebTestsList_563778 = ref object of OpenApiRestCall_563556
proc url_WebTestsList_563780(protocol: Scheme; host: string; base: string;
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

proc validate_WebTestsList_563779(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_563942 = path.getOrDefault("subscriptionId")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "subscriptionId", valid_563942
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563943 = query.getOrDefault("api-version")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "api-version", valid_563943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563970: Call_WebTestsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Application Insights web test alerts definitions within a subscription.
  ## 
  let valid = call_563970.validator(path, query, header, formData, body)
  let scheme = call_563970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563970.url(scheme.get, call_563970.host, call_563970.base,
                         call_563970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563970, url, valid)

proc call*(call_564041: Call_WebTestsList_563778; apiVersion: string;
          subscriptionId: string): Recallable =
  ## webTestsList
  ## Get all Application Insights web test alerts definitions within a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_564042 = newJObject()
  var query_564044 = newJObject()
  add(query_564044, "api-version", newJString(apiVersion))
  add(path_564042, "subscriptionId", newJString(subscriptionId))
  result = call_564041.call(path_564042, query_564044, nil, nil, nil)

var webTestsList* = Call_WebTestsList_563778(name: "webTestsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Insights/webtests",
    validator: validate_WebTestsList_563779, base: "", url: url_WebTestsList_563780,
    schemes: {Scheme.Https})
type
  Call_WebTestsListByComponent_564083 = ref object of OpenApiRestCall_563556
proc url_WebTestsListByComponent_564085(protocol: Scheme; host: string; base: string;
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

proc validate_WebTestsListByComponent_564084(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all Application Insights web tests defined for the specified component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   componentName: JString (required)
  ##                : The name of the Application Insights component resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `componentName` field"
  var valid_564095 = path.getOrDefault("componentName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "componentName", valid_564095
  var valid_564096 = path.getOrDefault("subscriptionId")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "subscriptionId", valid_564096
  var valid_564097 = path.getOrDefault("resourceGroupName")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "resourceGroupName", valid_564097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564098 = query.getOrDefault("api-version")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "api-version", valid_564098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564099: Call_WebTestsListByComponent_564083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Application Insights web tests defined for the specified component.
  ## 
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_WebTestsListByComponent_564083; componentName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## webTestsListByComponent
  ## Get all Application Insights web tests defined for the specified component.
  ##   componentName: string (required)
  ##                : The name of the Application Insights component resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564101 = newJObject()
  var query_564102 = newJObject()
  add(path_564101, "componentName", newJString(componentName))
  add(query_564102, "api-version", newJString(apiVersion))
  add(path_564101, "subscriptionId", newJString(subscriptionId))
  add(path_564101, "resourceGroupName", newJString(resourceGroupName))
  result = call_564100.call(path_564101, query_564102, nil, nil, nil)

var webTestsListByComponent* = Call_WebTestsListByComponent_564083(
    name: "webTestsListByComponent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{componentName}/webtests",
    validator: validate_WebTestsListByComponent_564084, base: "",
    url: url_WebTestsListByComponent_564085, schemes: {Scheme.Https})
type
  Call_WebTestsListByResourceGroup_564103 = ref object of OpenApiRestCall_563556
proc url_WebTestsListByResourceGroup_564105(protocol: Scheme; host: string;
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

proc validate_WebTestsListByResourceGroup_564104(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all Application Insights web tests defined within a specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564106 = path.getOrDefault("subscriptionId")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "subscriptionId", valid_564106
  var valid_564107 = path.getOrDefault("resourceGroupName")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "resourceGroupName", valid_564107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564108 = query.getOrDefault("api-version")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "api-version", valid_564108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564109: Call_WebTestsListByResourceGroup_564103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Application Insights web tests defined within a specified resource group.
  ## 
  let valid = call_564109.validator(path, query, header, formData, body)
  let scheme = call_564109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564109.url(scheme.get, call_564109.host, call_564109.base,
                         call_564109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564109, url, valid)

proc call*(call_564110: Call_WebTestsListByResourceGroup_564103;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## webTestsListByResourceGroup
  ## Get all Application Insights web tests defined within a specified resource group.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564111 = newJObject()
  var query_564112 = newJObject()
  add(query_564112, "api-version", newJString(apiVersion))
  add(path_564111, "subscriptionId", newJString(subscriptionId))
  add(path_564111, "resourceGroupName", newJString(resourceGroupName))
  result = call_564110.call(path_564111, query_564112, nil, nil, nil)

var webTestsListByResourceGroup* = Call_WebTestsListByResourceGroup_564103(
    name: "webTestsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/webtests",
    validator: validate_WebTestsListByResourceGroup_564104, base: "",
    url: url_WebTestsListByResourceGroup_564105, schemes: {Scheme.Https})
type
  Call_WebTestsCreateOrUpdate_564124 = ref object of OpenApiRestCall_563556
proc url_WebTestsCreateOrUpdate_564126(protocol: Scheme; host: string; base: string;
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

proc validate_WebTestsCreateOrUpdate_564125(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an Application Insights web test definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   webTestName: JString (required)
  ##              : The name of the Application Insights webtest resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564144 = path.getOrDefault("subscriptionId")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "subscriptionId", valid_564144
  var valid_564145 = path.getOrDefault("webTestName")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "webTestName", valid_564145
  var valid_564146 = path.getOrDefault("resourceGroupName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "resourceGroupName", valid_564146
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564147 = query.getOrDefault("api-version")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "api-version", valid_564147
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

proc call*(call_564149: Call_WebTestsCreateOrUpdate_564124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an Application Insights web test definition.
  ## 
  let valid = call_564149.validator(path, query, header, formData, body)
  let scheme = call_564149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564149.url(scheme.get, call_564149.host, call_564149.base,
                         call_564149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564149, url, valid)

proc call*(call_564150: Call_WebTestsCreateOrUpdate_564124;
          WebTestDefinition: JsonNode; apiVersion: string; subscriptionId: string;
          webTestName: string; resourceGroupName: string): Recallable =
  ## webTestsCreateOrUpdate
  ## Creates or updates an Application Insights web test definition.
  ##   WebTestDefinition: JObject (required)
  ##                    : Properties that need to be specified to create or update an Application Insights web test definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   webTestName: string (required)
  ##              : The name of the Application Insights webtest resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564151 = newJObject()
  var query_564152 = newJObject()
  var body_564153 = newJObject()
  if WebTestDefinition != nil:
    body_564153 = WebTestDefinition
  add(query_564152, "api-version", newJString(apiVersion))
  add(path_564151, "subscriptionId", newJString(subscriptionId))
  add(path_564151, "webTestName", newJString(webTestName))
  add(path_564151, "resourceGroupName", newJString(resourceGroupName))
  result = call_564150.call(path_564151, query_564152, nil, nil, body_564153)

var webTestsCreateOrUpdate* = Call_WebTestsCreateOrUpdate_564124(
    name: "webTestsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/webtests/{webTestName}",
    validator: validate_WebTestsCreateOrUpdate_564125, base: "",
    url: url_WebTestsCreateOrUpdate_564126, schemes: {Scheme.Https})
type
  Call_WebTestsGet_564113 = ref object of OpenApiRestCall_563556
proc url_WebTestsGet_564115(protocol: Scheme; host: string; base: string;
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

proc validate_WebTestsGet_564114(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific Application Insights web test definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   webTestName: JString (required)
  ##              : The name of the Application Insights webtest resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564116 = path.getOrDefault("subscriptionId")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "subscriptionId", valid_564116
  var valid_564117 = path.getOrDefault("webTestName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "webTestName", valid_564117
  var valid_564118 = path.getOrDefault("resourceGroupName")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "resourceGroupName", valid_564118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564120: Call_WebTestsGet_564113; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific Application Insights web test definition.
  ## 
  let valid = call_564120.validator(path, query, header, formData, body)
  let scheme = call_564120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564120.url(scheme.get, call_564120.host, call_564120.base,
                         call_564120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564120, url, valid)

proc call*(call_564121: Call_WebTestsGet_564113; apiVersion: string;
          subscriptionId: string; webTestName: string; resourceGroupName: string): Recallable =
  ## webTestsGet
  ## Get a specific Application Insights web test definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   webTestName: string (required)
  ##              : The name of the Application Insights webtest resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564122 = newJObject()
  var query_564123 = newJObject()
  add(query_564123, "api-version", newJString(apiVersion))
  add(path_564122, "subscriptionId", newJString(subscriptionId))
  add(path_564122, "webTestName", newJString(webTestName))
  add(path_564122, "resourceGroupName", newJString(resourceGroupName))
  result = call_564121.call(path_564122, query_564123, nil, nil, nil)

var webTestsGet* = Call_WebTestsGet_564113(name: "webTestsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/webtests/{webTestName}",
                                        validator: validate_WebTestsGet_564114,
                                        base: "", url: url_WebTestsGet_564115,
                                        schemes: {Scheme.Https})
type
  Call_WebTestsUpdateTags_564165 = ref object of OpenApiRestCall_563556
proc url_WebTestsUpdateTags_564167(protocol: Scheme; host: string; base: string;
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

proc validate_WebTestsUpdateTags_564166(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates or updates an Application Insights web test definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   webTestName: JString (required)
  ##              : The name of the Application Insights webtest resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564168 = path.getOrDefault("subscriptionId")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "subscriptionId", valid_564168
  var valid_564169 = path.getOrDefault("webTestName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "webTestName", valid_564169
  var valid_564170 = path.getOrDefault("resourceGroupName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "resourceGroupName", valid_564170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564171 = query.getOrDefault("api-version")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "api-version", valid_564171
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

proc call*(call_564173: Call_WebTestsUpdateTags_564165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an Application Insights web test definition.
  ## 
  let valid = call_564173.validator(path, query, header, formData, body)
  let scheme = call_564173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564173.url(scheme.get, call_564173.host, call_564173.base,
                         call_564173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564173, url, valid)

proc call*(call_564174: Call_WebTestsUpdateTags_564165; apiVersion: string;
          subscriptionId: string; webTestName: string; resourceGroupName: string;
          WebTestTags: JsonNode): Recallable =
  ## webTestsUpdateTags
  ## Creates or updates an Application Insights web test definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   webTestName: string (required)
  ##              : The name of the Application Insights webtest resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   WebTestTags: JObject (required)
  ##              : Updated tag information to set into the web test instance.
  var path_564175 = newJObject()
  var query_564176 = newJObject()
  var body_564177 = newJObject()
  add(query_564176, "api-version", newJString(apiVersion))
  add(path_564175, "subscriptionId", newJString(subscriptionId))
  add(path_564175, "webTestName", newJString(webTestName))
  add(path_564175, "resourceGroupName", newJString(resourceGroupName))
  if WebTestTags != nil:
    body_564177 = WebTestTags
  result = call_564174.call(path_564175, query_564176, nil, nil, body_564177)

var webTestsUpdateTags* = Call_WebTestsUpdateTags_564165(
    name: "webTestsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/webtests/{webTestName}",
    validator: validate_WebTestsUpdateTags_564166, base: "",
    url: url_WebTestsUpdateTags_564167, schemes: {Scheme.Https})
type
  Call_WebTestsDelete_564154 = ref object of OpenApiRestCall_563556
proc url_WebTestsDelete_564156(protocol: Scheme; host: string; base: string;
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

proc validate_WebTestsDelete_564155(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an Application Insights web test.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   webTestName: JString (required)
  ##              : The name of the Application Insights webtest resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564157 = path.getOrDefault("subscriptionId")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "subscriptionId", valid_564157
  var valid_564158 = path.getOrDefault("webTestName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "webTestName", valid_564158
  var valid_564159 = path.getOrDefault("resourceGroupName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "resourceGroupName", valid_564159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564160 = query.getOrDefault("api-version")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "api-version", valid_564160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564161: Call_WebTestsDelete_564154; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Application Insights web test.
  ## 
  let valid = call_564161.validator(path, query, header, formData, body)
  let scheme = call_564161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564161.url(scheme.get, call_564161.host, call_564161.base,
                         call_564161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564161, url, valid)

proc call*(call_564162: Call_WebTestsDelete_564154; apiVersion: string;
          subscriptionId: string; webTestName: string; resourceGroupName: string): Recallable =
  ## webTestsDelete
  ## Deletes an Application Insights web test.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   webTestName: string (required)
  ##              : The name of the Application Insights webtest resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564163 = newJObject()
  var query_564164 = newJObject()
  add(query_564164, "api-version", newJString(apiVersion))
  add(path_564163, "subscriptionId", newJString(subscriptionId))
  add(path_564163, "webTestName", newJString(webTestName))
  add(path_564163, "resourceGroupName", newJString(resourceGroupName))
  result = call_564162.call(path_564163, query_564164, nil, nil, nil)

var webTestsDelete* = Call_WebTestsDelete_564154(name: "webTestsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/webtests/{webTestName}",
    validator: validate_WebTestsDelete_564155, base: "", url: url_WebTestsDelete_564156,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
