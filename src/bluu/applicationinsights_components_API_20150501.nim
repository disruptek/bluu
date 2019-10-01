
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApplicationInsightsManagementClient
## version: 2015-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Application Insights client for Components.
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
  macServiceName = "applicationinsights-components_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ComponentsList_596680 = ref object of OpenApiRestCall_596458
proc url_ComponentsList_596682(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentsList_596681(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a list of all Application Insights components within a subscription.
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

proc call*(call_596870: Call_ComponentsList_596680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all Application Insights components within a subscription.
  ## 
  let valid = call_596870.validator(path, query, header, formData, body)
  let scheme = call_596870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596870.url(scheme.get, call_596870.host, call_596870.base,
                         call_596870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596870, url, valid)

proc call*(call_596941: Call_ComponentsList_596680; apiVersion: string;
          subscriptionId: string): Recallable =
  ## componentsList
  ## Gets a list of all Application Insights components within a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_596942 = newJObject()
  var query_596944 = newJObject()
  add(query_596944, "api-version", newJString(apiVersion))
  add(path_596942, "subscriptionId", newJString(subscriptionId))
  result = call_596941.call(path_596942, query_596944, nil, nil, nil)

var componentsList* = Call_ComponentsList_596680(name: "componentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Insights/components",
    validator: validate_ComponentsList_596681, base: "", url: url_ComponentsList_596682,
    schemes: {Scheme.Https})
type
  Call_ComponentsListByResourceGroup_596983 = ref object of OpenApiRestCall_596458
proc url_ComponentsListByResourceGroup_596985(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentsListByResourceGroup_596984(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of Application Insights components within a resource group.
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
  var valid_596986 = path.getOrDefault("resourceGroupName")
  valid_596986 = validateParameter(valid_596986, JString, required = true,
                                 default = nil)
  if valid_596986 != nil:
    section.add "resourceGroupName", valid_596986
  var valid_596987 = path.getOrDefault("subscriptionId")
  valid_596987 = validateParameter(valid_596987, JString, required = true,
                                 default = nil)
  if valid_596987 != nil:
    section.add "subscriptionId", valid_596987
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596988 = query.getOrDefault("api-version")
  valid_596988 = validateParameter(valid_596988, JString, required = true,
                                 default = nil)
  if valid_596988 != nil:
    section.add "api-version", valid_596988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596989: Call_ComponentsListByResourceGroup_596983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of Application Insights components within a resource group.
  ## 
  let valid = call_596989.validator(path, query, header, formData, body)
  let scheme = call_596989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596989.url(scheme.get, call_596989.host, call_596989.base,
                         call_596989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596989, url, valid)

proc call*(call_596990: Call_ComponentsListByResourceGroup_596983;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## componentsListByResourceGroup
  ## Gets a list of Application Insights components within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_596991 = newJObject()
  var query_596992 = newJObject()
  add(path_596991, "resourceGroupName", newJString(resourceGroupName))
  add(query_596992, "api-version", newJString(apiVersion))
  add(path_596991, "subscriptionId", newJString(subscriptionId))
  result = call_596990.call(path_596991, query_596992, nil, nil, nil)

var componentsListByResourceGroup* = Call_ComponentsListByResourceGroup_596983(
    name: "componentsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components",
    validator: validate_ComponentsListByResourceGroup_596984, base: "",
    url: url_ComponentsListByResourceGroup_596985, schemes: {Scheme.Https})
type
  Call_ComponentsCreateOrUpdate_597013 = ref object of OpenApiRestCall_596458
proc url_ComponentsCreateOrUpdate_597015(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentsCreateOrUpdate_597014(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates (or updates) an Application Insights component. Note: You cannot specify a different value for InstrumentationKey nor AppId in the Put operation.
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
  var valid_597033 = path.getOrDefault("resourceGroupName")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "resourceGroupName", valid_597033
  var valid_597034 = path.getOrDefault("subscriptionId")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "subscriptionId", valid_597034
  var valid_597035 = path.getOrDefault("resourceName")
  valid_597035 = validateParameter(valid_597035, JString, required = true,
                                 default = nil)
  if valid_597035 != nil:
    section.add "resourceName", valid_597035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597036 = query.getOrDefault("api-version")
  valid_597036 = validateParameter(valid_597036, JString, required = true,
                                 default = nil)
  if valid_597036 != nil:
    section.add "api-version", valid_597036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   InsightProperties: JObject (required)
  ##                    : Properties that need to be specified to create an Application Insights component.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597038: Call_ComponentsCreateOrUpdate_597013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates (or updates) an Application Insights component. Note: You cannot specify a different value for InstrumentationKey nor AppId in the Put operation.
  ## 
  let valid = call_597038.validator(path, query, header, formData, body)
  let scheme = call_597038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597038.url(scheme.get, call_597038.host, call_597038.base,
                         call_597038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597038, url, valid)

proc call*(call_597039: Call_ComponentsCreateOrUpdate_597013;
          resourceGroupName: string; apiVersion: string;
          InsightProperties: JsonNode; subscriptionId: string; resourceName: string): Recallable =
  ## componentsCreateOrUpdate
  ## Creates (or updates) an Application Insights component. Note: You cannot specify a different value for InstrumentationKey nor AppId in the Put operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   InsightProperties: JObject (required)
  ##                    : Properties that need to be specified to create an Application Insights component.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_597040 = newJObject()
  var query_597041 = newJObject()
  var body_597042 = newJObject()
  add(path_597040, "resourceGroupName", newJString(resourceGroupName))
  add(query_597041, "api-version", newJString(apiVersion))
  if InsightProperties != nil:
    body_597042 = InsightProperties
  add(path_597040, "subscriptionId", newJString(subscriptionId))
  add(path_597040, "resourceName", newJString(resourceName))
  result = call_597039.call(path_597040, query_597041, nil, nil, body_597042)

var componentsCreateOrUpdate* = Call_ComponentsCreateOrUpdate_597013(
    name: "componentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}",
    validator: validate_ComponentsCreateOrUpdate_597014, base: "",
    url: url_ComponentsCreateOrUpdate_597015, schemes: {Scheme.Https})
type
  Call_ComponentsGet_596993 = ref object of OpenApiRestCall_596458
proc url_ComponentsGet_596995(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentsGet_596994(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns an Application Insights component.
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
  var valid_597005 = path.getOrDefault("resourceGroupName")
  valid_597005 = validateParameter(valid_597005, JString, required = true,
                                 default = nil)
  if valid_597005 != nil:
    section.add "resourceGroupName", valid_597005
  var valid_597006 = path.getOrDefault("subscriptionId")
  valid_597006 = validateParameter(valid_597006, JString, required = true,
                                 default = nil)
  if valid_597006 != nil:
    section.add "subscriptionId", valid_597006
  var valid_597007 = path.getOrDefault("resourceName")
  valid_597007 = validateParameter(valid_597007, JString, required = true,
                                 default = nil)
  if valid_597007 != nil:
    section.add "resourceName", valid_597007
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

proc call*(call_597009: Call_ComponentsGet_596993; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an Application Insights component.
  ## 
  let valid = call_597009.validator(path, query, header, formData, body)
  let scheme = call_597009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597009.url(scheme.get, call_597009.host, call_597009.base,
                         call_597009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597009, url, valid)

proc call*(call_597010: Call_ComponentsGet_596993; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## componentsGet
  ## Returns an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_597011 = newJObject()
  var query_597012 = newJObject()
  add(path_597011, "resourceGroupName", newJString(resourceGroupName))
  add(query_597012, "api-version", newJString(apiVersion))
  add(path_597011, "subscriptionId", newJString(subscriptionId))
  add(path_597011, "resourceName", newJString(resourceName))
  result = call_597010.call(path_597011, query_597012, nil, nil, nil)

var componentsGet* = Call_ComponentsGet_596993(name: "componentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}",
    validator: validate_ComponentsGet_596994, base: "", url: url_ComponentsGet_596995,
    schemes: {Scheme.Https})
type
  Call_ComponentsUpdateTags_597054 = ref object of OpenApiRestCall_596458
proc url_ComponentsUpdateTags_597056(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentsUpdateTags_597055(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing component's tags. To update other fields use the CreateOrUpdate method.
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
  var valid_597057 = path.getOrDefault("resourceGroupName")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "resourceGroupName", valid_597057
  var valid_597058 = path.getOrDefault("subscriptionId")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "subscriptionId", valid_597058
  var valid_597059 = path.getOrDefault("resourceName")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "resourceName", valid_597059
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
  ## parameters in `body` object:
  ##   ComponentTags: JObject (required)
  ##                : Updated tag information to set into the component instance.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597062: Call_ComponentsUpdateTags_597054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing component's tags. To update other fields use the CreateOrUpdate method.
  ## 
  let valid = call_597062.validator(path, query, header, formData, body)
  let scheme = call_597062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597062.url(scheme.get, call_597062.host, call_597062.base,
                         call_597062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597062, url, valid)

proc call*(call_597063: Call_ComponentsUpdateTags_597054;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; ComponentTags: JsonNode): Recallable =
  ## componentsUpdateTags
  ## Updates an existing component's tags. To update other fields use the CreateOrUpdate method.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   ComponentTags: JObject (required)
  ##                : Updated tag information to set into the component instance.
  var path_597064 = newJObject()
  var query_597065 = newJObject()
  var body_597066 = newJObject()
  add(path_597064, "resourceGroupName", newJString(resourceGroupName))
  add(query_597065, "api-version", newJString(apiVersion))
  add(path_597064, "subscriptionId", newJString(subscriptionId))
  add(path_597064, "resourceName", newJString(resourceName))
  if ComponentTags != nil:
    body_597066 = ComponentTags
  result = call_597063.call(path_597064, query_597065, nil, nil, body_597066)

var componentsUpdateTags* = Call_ComponentsUpdateTags_597054(
    name: "componentsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}",
    validator: validate_ComponentsUpdateTags_597055, base: "",
    url: url_ComponentsUpdateTags_597056, schemes: {Scheme.Https})
type
  Call_ComponentsDelete_597043 = ref object of OpenApiRestCall_596458
proc url_ComponentsDelete_597045(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentsDelete_597044(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes an Application Insights component.
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
  var valid_597046 = path.getOrDefault("resourceGroupName")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "resourceGroupName", valid_597046
  var valid_597047 = path.getOrDefault("subscriptionId")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "subscriptionId", valid_597047
  var valid_597048 = path.getOrDefault("resourceName")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "resourceName", valid_597048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597049 = query.getOrDefault("api-version")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "api-version", valid_597049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597050: Call_ComponentsDelete_597043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Application Insights component.
  ## 
  let valid = call_597050.validator(path, query, header, formData, body)
  let scheme = call_597050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597050.url(scheme.get, call_597050.host, call_597050.base,
                         call_597050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597050, url, valid)

proc call*(call_597051: Call_ComponentsDelete_597043; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## componentsDelete
  ## Deletes an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_597052 = newJObject()
  var query_597053 = newJObject()
  add(path_597052, "resourceGroupName", newJString(resourceGroupName))
  add(query_597053, "api-version", newJString(apiVersion))
  add(path_597052, "subscriptionId", newJString(subscriptionId))
  add(path_597052, "resourceName", newJString(resourceName))
  result = call_597051.call(path_597052, query_597053, nil, nil, nil)

var componentsDelete* = Call_ComponentsDelete_597043(name: "componentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}",
    validator: validate_ComponentsDelete_597044, base: "",
    url: url_ComponentsDelete_597045, schemes: {Scheme.Https})
type
  Call_ComponentsGetPurgeStatus_597067 = ref object of OpenApiRestCall_596458
proc url_ComponentsGetPurgeStatus_597069(protocol: Scheme; host: string;
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
  assert "purgeId" in path, "`purgeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "purgeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentsGetPurgeStatus_597068(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get status for an ongoing purge operation.
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
  ##   purgeId: JString (required)
  ##          : In a purge status request, this is the Id of the operation the status of which is returned.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597070 = path.getOrDefault("resourceGroupName")
  valid_597070 = validateParameter(valid_597070, JString, required = true,
                                 default = nil)
  if valid_597070 != nil:
    section.add "resourceGroupName", valid_597070
  var valid_597071 = path.getOrDefault("subscriptionId")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = nil)
  if valid_597071 != nil:
    section.add "subscriptionId", valid_597071
  var valid_597072 = path.getOrDefault("resourceName")
  valid_597072 = validateParameter(valid_597072, JString, required = true,
                                 default = nil)
  if valid_597072 != nil:
    section.add "resourceName", valid_597072
  var valid_597073 = path.getOrDefault("purgeId")
  valid_597073 = validateParameter(valid_597073, JString, required = true,
                                 default = nil)
  if valid_597073 != nil:
    section.add "purgeId", valid_597073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597074 = query.getOrDefault("api-version")
  valid_597074 = validateParameter(valid_597074, JString, required = true,
                                 default = nil)
  if valid_597074 != nil:
    section.add "api-version", valid_597074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597075: Call_ComponentsGetPurgeStatus_597067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get status for an ongoing purge operation.
  ## 
  let valid = call_597075.validator(path, query, header, formData, body)
  let scheme = call_597075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597075.url(scheme.get, call_597075.host, call_597075.base,
                         call_597075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597075, url, valid)

proc call*(call_597076: Call_ComponentsGetPurgeStatus_597067;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; purgeId: string): Recallable =
  ## componentsGetPurgeStatus
  ## Get status for an ongoing purge operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   purgeId: string (required)
  ##          : In a purge status request, this is the Id of the operation the status of which is returned.
  var path_597077 = newJObject()
  var query_597078 = newJObject()
  add(path_597077, "resourceGroupName", newJString(resourceGroupName))
  add(query_597078, "api-version", newJString(apiVersion))
  add(path_597077, "subscriptionId", newJString(subscriptionId))
  add(path_597077, "resourceName", newJString(resourceName))
  add(path_597077, "purgeId", newJString(purgeId))
  result = call_597076.call(path_597077, query_597078, nil, nil, nil)

var componentsGetPurgeStatus* = Call_ComponentsGetPurgeStatus_597067(
    name: "componentsGetPurgeStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/operations/{purgeId}",
    validator: validate_ComponentsGetPurgeStatus_597068, base: "",
    url: url_ComponentsGetPurgeStatus_597069, schemes: {Scheme.Https})
type
  Call_ComponentsPurge_597079 = ref object of OpenApiRestCall_596458
proc url_ComponentsPurge_597081(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/purge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentsPurge_597080(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Purges data in an Application Insights component by a set of user-defined filters.
  ## 
  ## In order to manage system resources, purge requests are throttled at 50 requests per hour. You should batch the execution of purge requests by sending a single command whose predicate includes all user identities that require purging. Use the in operator to specify multiple identities. You should run the query prior to using for a purge request to verify that the results are expected.
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
  var valid_597082 = path.getOrDefault("resourceGroupName")
  valid_597082 = validateParameter(valid_597082, JString, required = true,
                                 default = nil)
  if valid_597082 != nil:
    section.add "resourceGroupName", valid_597082
  var valid_597083 = path.getOrDefault("subscriptionId")
  valid_597083 = validateParameter(valid_597083, JString, required = true,
                                 default = nil)
  if valid_597083 != nil:
    section.add "subscriptionId", valid_597083
  var valid_597084 = path.getOrDefault("resourceName")
  valid_597084 = validateParameter(valid_597084, JString, required = true,
                                 default = nil)
  if valid_597084 != nil:
    section.add "resourceName", valid_597084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597085 = query.getOrDefault("api-version")
  valid_597085 = validateParameter(valid_597085, JString, required = true,
                                 default = nil)
  if valid_597085 != nil:
    section.add "api-version", valid_597085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Describes the body of a request to purge data in a single table of an Application Insights component
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597087: Call_ComponentsPurge_597079; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Purges data in an Application Insights component by a set of user-defined filters.
  ## 
  ## In order to manage system resources, purge requests are throttled at 50 requests per hour. You should batch the execution of purge requests by sending a single command whose predicate includes all user identities that require purging. Use the in operator to specify multiple identities. You should run the query prior to using for a purge request to verify that the results are expected.
  ## 
  let valid = call_597087.validator(path, query, header, formData, body)
  let scheme = call_597087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597087.url(scheme.get, call_597087.host, call_597087.base,
                         call_597087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597087, url, valid)

proc call*(call_597088: Call_ComponentsPurge_597079; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          body: JsonNode): Recallable =
  ## componentsPurge
  ## Purges data in an Application Insights component by a set of user-defined filters.
  ## 
  ## In order to manage system resources, purge requests are throttled at 50 requests per hour. You should batch the execution of purge requests by sending a single command whose predicate includes all user identities that require purging. Use the in operator to specify multiple identities. You should run the query prior to using for a purge request to verify that the results are expected.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   body: JObject (required)
  ##       : Describes the body of a request to purge data in a single table of an Application Insights component
  var path_597089 = newJObject()
  var query_597090 = newJObject()
  var body_597091 = newJObject()
  add(path_597089, "resourceGroupName", newJString(resourceGroupName))
  add(query_597090, "api-version", newJString(apiVersion))
  add(path_597089, "subscriptionId", newJString(subscriptionId))
  add(path_597089, "resourceName", newJString(resourceName))
  if body != nil:
    body_597091 = body
  result = call_597088.call(path_597089, query_597090, nil, nil, body_597091)

var componentsPurge* = Call_ComponentsPurge_597079(name: "componentsPurge",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/purge",
    validator: validate_ComponentsPurge_597080, base: "", url: url_ComponentsPurge_597081,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
