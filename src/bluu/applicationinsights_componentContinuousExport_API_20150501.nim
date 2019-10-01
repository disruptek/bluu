
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApplicationInsightsManagementClient
## version: 2015-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Application Insights client for Continuous Export of a component.
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

  OpenApiRestCall_596457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596457): Option[Scheme] {.used.} =
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
  macServiceName = "applicationinsights-componentContinuousExport_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ExportConfigurationsCreate_596993 = ref object of OpenApiRestCall_596457
proc url_ExportConfigurationsCreate_596995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/exportconfiguration")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportConfigurationsCreate_596994(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a Continuous Export configuration of an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596996 = path.getOrDefault("resourceGroupName")
  valid_596996 = validateParameter(valid_596996, JString, required = true,
                                 default = nil)
  if valid_596996 != nil:
    section.add "resourceGroupName", valid_596996
  var valid_596997 = path.getOrDefault("subscriptionId")
  valid_596997 = validateParameter(valid_596997, JString, required = true,
                                 default = nil)
  if valid_596997 != nil:
    section.add "subscriptionId", valid_596997
  var valid_596998 = path.getOrDefault("resourceName")
  valid_596998 = validateParameter(valid_596998, JString, required = true,
                                 default = nil)
  if valid_596998 != nil:
    section.add "resourceName", valid_596998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596999 = query.getOrDefault("api-version")
  valid_596999 = validateParameter(valid_596999, JString, required = true,
                                 default = nil)
  if valid_596999 != nil:
    section.add "api-version", valid_596999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ExportProperties: JObject (required)
  ##                   : Properties that need to be specified to create a Continuous Export configuration of a Application Insights component.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597001: Call_ExportConfigurationsCreate_596993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a Continuous Export configuration of an Application Insights component.
  ## 
  let valid = call_597001.validator(path, query, header, formData, body)
  let scheme = call_597001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597001.url(scheme.get, call_597001.host, call_597001.base,
                         call_597001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597001, url, valid)

proc call*(call_597002: Call_ExportConfigurationsCreate_596993;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; ExportProperties: JsonNode): Recallable =
  ## exportConfigurationsCreate
  ## Create a Continuous Export configuration of an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   ExportProperties: JObject (required)
  ##                   : Properties that need to be specified to create a Continuous Export configuration of a Application Insights component.
  var path_597003 = newJObject()
  var query_597004 = newJObject()
  var body_597005 = newJObject()
  add(path_597003, "resourceGroupName", newJString(resourceGroupName))
  add(query_597004, "api-version", newJString(apiVersion))
  add(path_597003, "subscriptionId", newJString(subscriptionId))
  add(path_597003, "resourceName", newJString(resourceName))
  if ExportProperties != nil:
    body_597005 = ExportProperties
  result = call_597002.call(path_597003, query_597004, nil, nil, body_597005)

var exportConfigurationsCreate* = Call_ExportConfigurationsCreate_596993(
    name: "exportConfigurationsCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/exportconfiguration",
    validator: validate_ExportConfigurationsCreate_596994, base: "",
    url: url_ExportConfigurationsCreate_596995, schemes: {Scheme.Https})
type
  Call_ExportConfigurationsList_596679 = ref object of OpenApiRestCall_596457
proc url_ExportConfigurationsList_596681(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/exportconfiguration")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportConfigurationsList_596680(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of Continuous Export configuration of an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596854 = path.getOrDefault("resourceGroupName")
  valid_596854 = validateParameter(valid_596854, JString, required = true,
                                 default = nil)
  if valid_596854 != nil:
    section.add "resourceGroupName", valid_596854
  var valid_596855 = path.getOrDefault("subscriptionId")
  valid_596855 = validateParameter(valid_596855, JString, required = true,
                                 default = nil)
  if valid_596855 != nil:
    section.add "subscriptionId", valid_596855
  var valid_596856 = path.getOrDefault("resourceName")
  valid_596856 = validateParameter(valid_596856, JString, required = true,
                                 default = nil)
  if valid_596856 != nil:
    section.add "resourceName", valid_596856
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596857 = query.getOrDefault("api-version")
  valid_596857 = validateParameter(valid_596857, JString, required = true,
                                 default = nil)
  if valid_596857 != nil:
    section.add "api-version", valid_596857
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596880: Call_ExportConfigurationsList_596679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of Continuous Export configuration of an Application Insights component.
  ## 
  let valid = call_596880.validator(path, query, header, formData, body)
  let scheme = call_596880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596880.url(scheme.get, call_596880.host, call_596880.base,
                         call_596880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596880, url, valid)

proc call*(call_596951: Call_ExportConfigurationsList_596679;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## exportConfigurationsList
  ## Gets a list of Continuous Export configuration of an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_596952 = newJObject()
  var query_596954 = newJObject()
  add(path_596952, "resourceGroupName", newJString(resourceGroupName))
  add(query_596954, "api-version", newJString(apiVersion))
  add(path_596952, "subscriptionId", newJString(subscriptionId))
  add(path_596952, "resourceName", newJString(resourceName))
  result = call_596951.call(path_596952, query_596954, nil, nil, nil)

var exportConfigurationsList* = Call_ExportConfigurationsList_596679(
    name: "exportConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/exportconfiguration",
    validator: validate_ExportConfigurationsList_596680, base: "",
    url: url_ExportConfigurationsList_596681, schemes: {Scheme.Https})
type
  Call_ExportConfigurationsUpdate_597018 = ref object of OpenApiRestCall_596457
proc url_ExportConfigurationsUpdate_597020(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "exportId" in path, "`exportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/exportconfiguration/"),
               (kind: VariableSegment, value: "exportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportConfigurationsUpdate_597019(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the Continuous Export configuration for this export id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   exportId: JString (required)
  ##           : The Continuous Export configuration ID. This is unique within a Application Insights component.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597021 = path.getOrDefault("resourceGroupName")
  valid_597021 = validateParameter(valid_597021, JString, required = true,
                                 default = nil)
  if valid_597021 != nil:
    section.add "resourceGroupName", valid_597021
  var valid_597022 = path.getOrDefault("exportId")
  valid_597022 = validateParameter(valid_597022, JString, required = true,
                                 default = nil)
  if valid_597022 != nil:
    section.add "exportId", valid_597022
  var valid_597023 = path.getOrDefault("subscriptionId")
  valid_597023 = validateParameter(valid_597023, JString, required = true,
                                 default = nil)
  if valid_597023 != nil:
    section.add "subscriptionId", valid_597023
  var valid_597024 = path.getOrDefault("resourceName")
  valid_597024 = validateParameter(valid_597024, JString, required = true,
                                 default = nil)
  if valid_597024 != nil:
    section.add "resourceName", valid_597024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597025 = query.getOrDefault("api-version")
  valid_597025 = validateParameter(valid_597025, JString, required = true,
                                 default = nil)
  if valid_597025 != nil:
    section.add "api-version", valid_597025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ExportProperties: JObject (required)
  ##                   : Properties that need to be specified to update the Continuous Export configuration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597027: Call_ExportConfigurationsUpdate_597018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the Continuous Export configuration for this export id.
  ## 
  let valid = call_597027.validator(path, query, header, formData, body)
  let scheme = call_597027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597027.url(scheme.get, call_597027.host, call_597027.base,
                         call_597027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597027, url, valid)

proc call*(call_597028: Call_ExportConfigurationsUpdate_597018;
          resourceGroupName: string; apiVersion: string; exportId: string;
          subscriptionId: string; resourceName: string; ExportProperties: JsonNode): Recallable =
  ## exportConfigurationsUpdate
  ## Update the Continuous Export configuration for this export id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   exportId: string (required)
  ##           : The Continuous Export configuration ID. This is unique within a Application Insights component.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   ExportProperties: JObject (required)
  ##                   : Properties that need to be specified to update the Continuous Export configuration.
  var path_597029 = newJObject()
  var query_597030 = newJObject()
  var body_597031 = newJObject()
  add(path_597029, "resourceGroupName", newJString(resourceGroupName))
  add(query_597030, "api-version", newJString(apiVersion))
  add(path_597029, "exportId", newJString(exportId))
  add(path_597029, "subscriptionId", newJString(subscriptionId))
  add(path_597029, "resourceName", newJString(resourceName))
  if ExportProperties != nil:
    body_597031 = ExportProperties
  result = call_597028.call(path_597029, query_597030, nil, nil, body_597031)

var exportConfigurationsUpdate* = Call_ExportConfigurationsUpdate_597018(
    name: "exportConfigurationsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/exportconfiguration/{exportId}",
    validator: validate_ExportConfigurationsUpdate_597019, base: "",
    url: url_ExportConfigurationsUpdate_597020, schemes: {Scheme.Https})
type
  Call_ExportConfigurationsGet_597006 = ref object of OpenApiRestCall_596457
proc url_ExportConfigurationsGet_597008(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "exportId" in path, "`exportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/exportconfiguration/"),
               (kind: VariableSegment, value: "exportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportConfigurationsGet_597007(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the Continuous Export configuration for this export id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   exportId: JString (required)
  ##           : The Continuous Export configuration ID. This is unique within a Application Insights component.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597009 = path.getOrDefault("resourceGroupName")
  valid_597009 = validateParameter(valid_597009, JString, required = true,
                                 default = nil)
  if valid_597009 != nil:
    section.add "resourceGroupName", valid_597009
  var valid_597010 = path.getOrDefault("exportId")
  valid_597010 = validateParameter(valid_597010, JString, required = true,
                                 default = nil)
  if valid_597010 != nil:
    section.add "exportId", valid_597010
  var valid_597011 = path.getOrDefault("subscriptionId")
  valid_597011 = validateParameter(valid_597011, JString, required = true,
                                 default = nil)
  if valid_597011 != nil:
    section.add "subscriptionId", valid_597011
  var valid_597012 = path.getOrDefault("resourceName")
  valid_597012 = validateParameter(valid_597012, JString, required = true,
                                 default = nil)
  if valid_597012 != nil:
    section.add "resourceName", valid_597012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597013 = query.getOrDefault("api-version")
  valid_597013 = validateParameter(valid_597013, JString, required = true,
                                 default = nil)
  if valid_597013 != nil:
    section.add "api-version", valid_597013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597014: Call_ExportConfigurationsGet_597006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the Continuous Export configuration for this export id.
  ## 
  let valid = call_597014.validator(path, query, header, formData, body)
  let scheme = call_597014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597014.url(scheme.get, call_597014.host, call_597014.base,
                         call_597014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597014, url, valid)

proc call*(call_597015: Call_ExportConfigurationsGet_597006;
          resourceGroupName: string; apiVersion: string; exportId: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## exportConfigurationsGet
  ## Get the Continuous Export configuration for this export id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   exportId: string (required)
  ##           : The Continuous Export configuration ID. This is unique within a Application Insights component.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_597016 = newJObject()
  var query_597017 = newJObject()
  add(path_597016, "resourceGroupName", newJString(resourceGroupName))
  add(query_597017, "api-version", newJString(apiVersion))
  add(path_597016, "exportId", newJString(exportId))
  add(path_597016, "subscriptionId", newJString(subscriptionId))
  add(path_597016, "resourceName", newJString(resourceName))
  result = call_597015.call(path_597016, query_597017, nil, nil, nil)

var exportConfigurationsGet* = Call_ExportConfigurationsGet_597006(
    name: "exportConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/exportconfiguration/{exportId}",
    validator: validate_ExportConfigurationsGet_597007, base: "",
    url: url_ExportConfigurationsGet_597008, schemes: {Scheme.Https})
type
  Call_ExportConfigurationsDelete_597032 = ref object of OpenApiRestCall_596457
proc url_ExportConfigurationsDelete_597034(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "exportId" in path, "`exportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/exportconfiguration/"),
               (kind: VariableSegment, value: "exportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportConfigurationsDelete_597033(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Continuous Export configuration of an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   exportId: JString (required)
  ##           : The Continuous Export configuration ID. This is unique within a Application Insights component.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597035 = path.getOrDefault("resourceGroupName")
  valid_597035 = validateParameter(valid_597035, JString, required = true,
                                 default = nil)
  if valid_597035 != nil:
    section.add "resourceGroupName", valid_597035
  var valid_597036 = path.getOrDefault("exportId")
  valid_597036 = validateParameter(valid_597036, JString, required = true,
                                 default = nil)
  if valid_597036 != nil:
    section.add "exportId", valid_597036
  var valid_597037 = path.getOrDefault("subscriptionId")
  valid_597037 = validateParameter(valid_597037, JString, required = true,
                                 default = nil)
  if valid_597037 != nil:
    section.add "subscriptionId", valid_597037
  var valid_597038 = path.getOrDefault("resourceName")
  valid_597038 = validateParameter(valid_597038, JString, required = true,
                                 default = nil)
  if valid_597038 != nil:
    section.add "resourceName", valid_597038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597039 = query.getOrDefault("api-version")
  valid_597039 = validateParameter(valid_597039, JString, required = true,
                                 default = nil)
  if valid_597039 != nil:
    section.add "api-version", valid_597039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597040: Call_ExportConfigurationsDelete_597032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Continuous Export configuration of an Application Insights component.
  ## 
  let valid = call_597040.validator(path, query, header, formData, body)
  let scheme = call_597040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597040.url(scheme.get, call_597040.host, call_597040.base,
                         call_597040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597040, url, valid)

proc call*(call_597041: Call_ExportConfigurationsDelete_597032;
          resourceGroupName: string; apiVersion: string; exportId: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## exportConfigurationsDelete
  ## Delete a Continuous Export configuration of an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   exportId: string (required)
  ##           : The Continuous Export configuration ID. This is unique within a Application Insights component.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_597042 = newJObject()
  var query_597043 = newJObject()
  add(path_597042, "resourceGroupName", newJString(resourceGroupName))
  add(query_597043, "api-version", newJString(apiVersion))
  add(path_597042, "exportId", newJString(exportId))
  add(path_597042, "subscriptionId", newJString(subscriptionId))
  add(path_597042, "resourceName", newJString(resourceName))
  result = call_597041.call(path_597042, query_597043, nil, nil, nil)

var exportConfigurationsDelete* = Call_ExportConfigurationsDelete_597032(
    name: "exportConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/exportconfiguration/{exportId}",
    validator: validate_ExportConfigurationsDelete_597033, base: "",
    url: url_ExportConfigurationsDelete_597034, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
