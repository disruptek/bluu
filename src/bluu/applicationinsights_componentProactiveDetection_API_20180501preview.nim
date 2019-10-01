
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_596442 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596442](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596442): Option[Scheme] {.used.} =
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
  macServiceName = "applicationinsights-componentProactiveDetection_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProactiveDetectionConfigurationsList_596664 = ref object of OpenApiRestCall_596442
proc url_ProactiveDetectionConfigurationsList_596666(protocol: Scheme;
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

proc validate_ProactiveDetectionConfigurationsList_596665(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of ProactiveDetection configurations of an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596839 = path.getOrDefault("resourceGroupName")
  valid_596839 = validateParameter(valid_596839, JString, required = true,
                                 default = nil)
  if valid_596839 != nil:
    section.add "resourceGroupName", valid_596839
  var valid_596840 = path.getOrDefault("subscriptionId")
  valid_596840 = validateParameter(valid_596840, JString, required = true,
                                 default = nil)
  if valid_596840 != nil:
    section.add "subscriptionId", valid_596840
  var valid_596841 = path.getOrDefault("resourceName")
  valid_596841 = validateParameter(valid_596841, JString, required = true,
                                 default = nil)
  if valid_596841 != nil:
    section.add "resourceName", valid_596841
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596842 = query.getOrDefault("api-version")
  valid_596842 = validateParameter(valid_596842, JString, required = true,
                                 default = nil)
  if valid_596842 != nil:
    section.add "api-version", valid_596842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596865: Call_ProactiveDetectionConfigurationsList_596664;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of ProactiveDetection configurations of an Application Insights component.
  ## 
  let valid = call_596865.validator(path, query, header, formData, body)
  let scheme = call_596865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596865.url(scheme.get, call_596865.host, call_596865.base,
                         call_596865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596865, url, valid)

proc call*(call_596936: Call_ProactiveDetectionConfigurationsList_596664;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## proactiveDetectionConfigurationsList
  ## Gets a list of ProactiveDetection configurations of an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_596937 = newJObject()
  var query_596939 = newJObject()
  add(path_596937, "resourceGroupName", newJString(resourceGroupName))
  add(query_596939, "api-version", newJString(apiVersion))
  add(path_596937, "subscriptionId", newJString(subscriptionId))
  add(path_596937, "resourceName", newJString(resourceName))
  result = call_596936.call(path_596937, query_596939, nil, nil, nil)

var proactiveDetectionConfigurationsList* = Call_ProactiveDetectionConfigurationsList_596664(
    name: "proactiveDetectionConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/ProactiveDetectionConfigs",
    validator: validate_ProactiveDetectionConfigurationsList_596665, base: "",
    url: url_ProactiveDetectionConfigurationsList_596666, schemes: {Scheme.Https})
type
  Call_ProactiveDetectionConfigurationsUpdate_596990 = ref object of OpenApiRestCall_596442
proc url_ProactiveDetectionConfigurationsUpdate_596992(protocol: Scheme;
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

proc validate_ProactiveDetectionConfigurationsUpdate_596991(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the ProactiveDetection configuration for this configuration id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ConfigurationId: JString (required)
  ##                  : The ProactiveDetection configuration ID. This is unique within a Application Insights component.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ConfigurationId` field"
  var valid_596993 = path.getOrDefault("ConfigurationId")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "ConfigurationId", valid_596993
  var valid_596994 = path.getOrDefault("resourceGroupName")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "resourceGroupName", valid_596994
  var valid_596995 = path.getOrDefault("subscriptionId")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "subscriptionId", valid_596995
  var valid_596996 = path.getOrDefault("resourceName")
  valid_596996 = validateParameter(valid_596996, JString, required = true,
                                 default = nil)
  if valid_596996 != nil:
    section.add "resourceName", valid_596996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596997 = query.getOrDefault("api-version")
  valid_596997 = validateParameter(valid_596997, JString, required = true,
                                 default = nil)
  if valid_596997 != nil:
    section.add "api-version", valid_596997
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

proc call*(call_596999: Call_ProactiveDetectionConfigurationsUpdate_596990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the ProactiveDetection configuration for this configuration id.
  ## 
  let valid = call_596999.validator(path, query, header, formData, body)
  let scheme = call_596999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596999.url(scheme.get, call_596999.host, call_596999.base,
                         call_596999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596999, url, valid)

proc call*(call_597000: Call_ProactiveDetectionConfigurationsUpdate_596990;
          ConfigurationId: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          ProactiveDetectionProperties: JsonNode): Recallable =
  ## proactiveDetectionConfigurationsUpdate
  ## Update the ProactiveDetection configuration for this configuration id.
  ##   ConfigurationId: string (required)
  ##                  : The ProactiveDetection configuration ID. This is unique within a Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   ProactiveDetectionProperties: JObject (required)
  ##                               : Properties that need to be specified to update the ProactiveDetection configuration.
  var path_597001 = newJObject()
  var query_597002 = newJObject()
  var body_597003 = newJObject()
  add(path_597001, "ConfigurationId", newJString(ConfigurationId))
  add(path_597001, "resourceGroupName", newJString(resourceGroupName))
  add(query_597002, "api-version", newJString(apiVersion))
  add(path_597001, "subscriptionId", newJString(subscriptionId))
  add(path_597001, "resourceName", newJString(resourceName))
  if ProactiveDetectionProperties != nil:
    body_597003 = ProactiveDetectionProperties
  result = call_597000.call(path_597001, query_597002, nil, nil, body_597003)

var proactiveDetectionConfigurationsUpdate* = Call_ProactiveDetectionConfigurationsUpdate_596990(
    name: "proactiveDetectionConfigurationsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/ProactiveDetectionConfigs/{ConfigurationId}",
    validator: validate_ProactiveDetectionConfigurationsUpdate_596991, base: "",
    url: url_ProactiveDetectionConfigurationsUpdate_596992,
    schemes: {Scheme.Https})
type
  Call_ProactiveDetectionConfigurationsGet_596978 = ref object of OpenApiRestCall_596442
proc url_ProactiveDetectionConfigurationsGet_596980(protocol: Scheme; host: string;
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

proc validate_ProactiveDetectionConfigurationsGet_596979(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the ProactiveDetection configuration for this configuration id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ConfigurationId: JString (required)
  ##                  : The ProactiveDetection configuration ID. This is unique within a Application Insights component.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ConfigurationId` field"
  var valid_596981 = path.getOrDefault("ConfigurationId")
  valid_596981 = validateParameter(valid_596981, JString, required = true,
                                 default = nil)
  if valid_596981 != nil:
    section.add "ConfigurationId", valid_596981
  var valid_596982 = path.getOrDefault("resourceGroupName")
  valid_596982 = validateParameter(valid_596982, JString, required = true,
                                 default = nil)
  if valid_596982 != nil:
    section.add "resourceGroupName", valid_596982
  var valid_596983 = path.getOrDefault("subscriptionId")
  valid_596983 = validateParameter(valid_596983, JString, required = true,
                                 default = nil)
  if valid_596983 != nil:
    section.add "subscriptionId", valid_596983
  var valid_596984 = path.getOrDefault("resourceName")
  valid_596984 = validateParameter(valid_596984, JString, required = true,
                                 default = nil)
  if valid_596984 != nil:
    section.add "resourceName", valid_596984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596985 = query.getOrDefault("api-version")
  valid_596985 = validateParameter(valid_596985, JString, required = true,
                                 default = nil)
  if valid_596985 != nil:
    section.add "api-version", valid_596985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596986: Call_ProactiveDetectionConfigurationsGet_596978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the ProactiveDetection configuration for this configuration id.
  ## 
  let valid = call_596986.validator(path, query, header, formData, body)
  let scheme = call_596986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596986.url(scheme.get, call_596986.host, call_596986.base,
                         call_596986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596986, url, valid)

proc call*(call_596987: Call_ProactiveDetectionConfigurationsGet_596978;
          ConfigurationId: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## proactiveDetectionConfigurationsGet
  ## Get the ProactiveDetection configuration for this configuration id.
  ##   ConfigurationId: string (required)
  ##                  : The ProactiveDetection configuration ID. This is unique within a Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_596988 = newJObject()
  var query_596989 = newJObject()
  add(path_596988, "ConfigurationId", newJString(ConfigurationId))
  add(path_596988, "resourceGroupName", newJString(resourceGroupName))
  add(query_596989, "api-version", newJString(apiVersion))
  add(path_596988, "subscriptionId", newJString(subscriptionId))
  add(path_596988, "resourceName", newJString(resourceName))
  result = call_596987.call(path_596988, query_596989, nil, nil, nil)

var proactiveDetectionConfigurationsGet* = Call_ProactiveDetectionConfigurationsGet_596978(
    name: "proactiveDetectionConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/ProactiveDetectionConfigs/{ConfigurationId}",
    validator: validate_ProactiveDetectionConfigurationsGet_596979, base: "",
    url: url_ProactiveDetectionConfigurationsGet_596980, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
