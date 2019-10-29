
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApplicationInsightsManagementClient
## version: 2018-05-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Application Insights client for ProactiveDetection configurations of a component.
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

  OpenApiRestCall_563540 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563540](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563540): Option[Scheme] {.used.} =
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
  macServiceName = "applicationinsights-componentProactiveDetection_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProactiveDetectionConfigurationsList_563762 = ref object of OpenApiRestCall_563540
proc url_ProactiveDetectionConfigurationsList_563764(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/ProactiveDetectionConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProactiveDetectionConfigurationsList_563763(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of ProactiveDetection configurations of an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563939 = path.getOrDefault("subscriptionId")
  valid_563939 = validateParameter(valid_563939, JString, required = true,
                                 default = nil)
  if valid_563939 != nil:
    section.add "subscriptionId", valid_563939
  var valid_563940 = path.getOrDefault("resourceGroupName")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "resourceGroupName", valid_563940
  var valid_563941 = path.getOrDefault("resourceName")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "resourceName", valid_563941
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563942 = query.getOrDefault("api-version")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "api-version", valid_563942
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563965: Call_ProactiveDetectionConfigurationsList_563762;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of ProactiveDetection configurations of an Application Insights component.
  ## 
  let valid = call_563965.validator(path, query, header, formData, body)
  let scheme = call_563965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563965.url(scheme.get, call_563965.host, call_563965.base,
                         call_563965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563965, url, valid)

proc call*(call_564036: Call_ProactiveDetectionConfigurationsList_563762;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## proactiveDetectionConfigurationsList
  ## Gets a list of ProactiveDetection configurations of an Application Insights component.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_564037 = newJObject()
  var query_564039 = newJObject()
  add(query_564039, "api-version", newJString(apiVersion))
  add(path_564037, "subscriptionId", newJString(subscriptionId))
  add(path_564037, "resourceGroupName", newJString(resourceGroupName))
  add(path_564037, "resourceName", newJString(resourceName))
  result = call_564036.call(path_564037, query_564039, nil, nil, nil)

var proactiveDetectionConfigurationsList* = Call_ProactiveDetectionConfigurationsList_563762(
    name: "proactiveDetectionConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/ProactiveDetectionConfigs",
    validator: validate_ProactiveDetectionConfigurationsList_563763, base: "",
    url: url_ProactiveDetectionConfigurationsList_563764, schemes: {Scheme.Https})
type
  Call_ProactiveDetectionConfigurationsUpdate_564090 = ref object of OpenApiRestCall_563540
proc url_ProactiveDetectionConfigurationsUpdate_564092(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "ConfigurationId" in path, "`ConfigurationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/ProactiveDetectionConfigs/"),
               (kind: VariableSegment, value: "ConfigurationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProactiveDetectionConfigurationsUpdate_564091(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the ProactiveDetection configuration for this configuration id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ConfigurationId: JString (required)
  ##                  : The ProactiveDetection configuration ID. This is unique within a Application Insights component.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ConfigurationId` field"
  var valid_564093 = path.getOrDefault("ConfigurationId")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "ConfigurationId", valid_564093
  var valid_564094 = path.getOrDefault("subscriptionId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "subscriptionId", valid_564094
  var valid_564095 = path.getOrDefault("resourceGroupName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "resourceGroupName", valid_564095
  var valid_564096 = path.getOrDefault("resourceName")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "resourceName", valid_564096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564097 = query.getOrDefault("api-version")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "api-version", valid_564097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ProactiveDetectionProperties: JObject (required)
  ##                               : Properties that need to be specified to update the ProactiveDetection configuration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564099: Call_ProactiveDetectionConfigurationsUpdate_564090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the ProactiveDetection configuration for this configuration id.
  ## 
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_ProactiveDetectionConfigurationsUpdate_564090;
          ProactiveDetectionProperties: JsonNode; apiVersion: string;
          ConfigurationId: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## proactiveDetectionConfigurationsUpdate
  ## Update the ProactiveDetection configuration for this configuration id.
  ##   ProactiveDetectionProperties: JObject (required)
  ##                               : Properties that need to be specified to update the ProactiveDetection configuration.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   ConfigurationId: string (required)
  ##                  : The ProactiveDetection configuration ID. This is unique within a Application Insights component.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_564101 = newJObject()
  var query_564102 = newJObject()
  var body_564103 = newJObject()
  if ProactiveDetectionProperties != nil:
    body_564103 = ProactiveDetectionProperties
  add(query_564102, "api-version", newJString(apiVersion))
  add(path_564101, "ConfigurationId", newJString(ConfigurationId))
  add(path_564101, "subscriptionId", newJString(subscriptionId))
  add(path_564101, "resourceGroupName", newJString(resourceGroupName))
  add(path_564101, "resourceName", newJString(resourceName))
  result = call_564100.call(path_564101, query_564102, nil, nil, body_564103)

var proactiveDetectionConfigurationsUpdate* = Call_ProactiveDetectionConfigurationsUpdate_564090(
    name: "proactiveDetectionConfigurationsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/ProactiveDetectionConfigs/{ConfigurationId}",
    validator: validate_ProactiveDetectionConfigurationsUpdate_564091, base: "",
    url: url_ProactiveDetectionConfigurationsUpdate_564092,
    schemes: {Scheme.Https})
type
  Call_ProactiveDetectionConfigurationsGet_564078 = ref object of OpenApiRestCall_563540
proc url_ProactiveDetectionConfigurationsGet_564080(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "ConfigurationId" in path, "`ConfigurationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/ProactiveDetectionConfigs/"),
               (kind: VariableSegment, value: "ConfigurationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProactiveDetectionConfigurationsGet_564079(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the ProactiveDetection configuration for this configuration id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ConfigurationId: JString (required)
  ##                  : The ProactiveDetection configuration ID. This is unique within a Application Insights component.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ConfigurationId` field"
  var valid_564081 = path.getOrDefault("ConfigurationId")
  valid_564081 = validateParameter(valid_564081, JString, required = true,
                                 default = nil)
  if valid_564081 != nil:
    section.add "ConfigurationId", valid_564081
  var valid_564082 = path.getOrDefault("subscriptionId")
  valid_564082 = validateParameter(valid_564082, JString, required = true,
                                 default = nil)
  if valid_564082 != nil:
    section.add "subscriptionId", valid_564082
  var valid_564083 = path.getOrDefault("resourceGroupName")
  valid_564083 = validateParameter(valid_564083, JString, required = true,
                                 default = nil)
  if valid_564083 != nil:
    section.add "resourceGroupName", valid_564083
  var valid_564084 = path.getOrDefault("resourceName")
  valid_564084 = validateParameter(valid_564084, JString, required = true,
                                 default = nil)
  if valid_564084 != nil:
    section.add "resourceName", valid_564084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564085 = query.getOrDefault("api-version")
  valid_564085 = validateParameter(valid_564085, JString, required = true,
                                 default = nil)
  if valid_564085 != nil:
    section.add "api-version", valid_564085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564086: Call_ProactiveDetectionConfigurationsGet_564078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the ProactiveDetection configuration for this configuration id.
  ## 
  let valid = call_564086.validator(path, query, header, formData, body)
  let scheme = call_564086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564086.url(scheme.get, call_564086.host, call_564086.base,
                         call_564086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564086, url, valid)

proc call*(call_564087: Call_ProactiveDetectionConfigurationsGet_564078;
          apiVersion: string; ConfigurationId: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## proactiveDetectionConfigurationsGet
  ## Get the ProactiveDetection configuration for this configuration id.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   ConfigurationId: string (required)
  ##                  : The ProactiveDetection configuration ID. This is unique within a Application Insights component.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_564088 = newJObject()
  var query_564089 = newJObject()
  add(query_564089, "api-version", newJString(apiVersion))
  add(path_564088, "ConfigurationId", newJString(ConfigurationId))
  add(path_564088, "subscriptionId", newJString(subscriptionId))
  add(path_564088, "resourceGroupName", newJString(resourceGroupName))
  add(path_564088, "resourceName", newJString(resourceName))
  result = call_564087.call(path_564088, query_564089, nil, nil, nil)

var proactiveDetectionConfigurationsGet* = Call_ProactiveDetectionConfigurationsGet_564078(
    name: "proactiveDetectionConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/ProactiveDetectionConfigs/{ConfigurationId}",
    validator: validate_ProactiveDetectionConfigurationsGet_564079, base: "",
    url: url_ProactiveDetectionConfigurationsGet_564080, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
