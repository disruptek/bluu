
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AppServicePlans API Client
## version: 2016-09-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "web-AppServicePlans"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppServicePlansList_567879 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansList_567881(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansList_567880(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get all App Service plans for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568054 = path.getOrDefault("subscriptionId")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "subscriptionId", valid_568054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   detailed: JBool
  ##           : Specify <code>true</code> to return all App Service plan properties. The default is <code>false</code>, which returns a subset of the properties.
  ##  Retrieval of all properties may increase the API latency.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568055 = query.getOrDefault("api-version")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "api-version", valid_568055
  var valid_568056 = query.getOrDefault("detailed")
  valid_568056 = validateParameter(valid_568056, JBool, required = false, default = nil)
  if valid_568056 != nil:
    section.add "detailed", valid_568056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568079: Call_AppServicePlansList_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all App Service plans for a subscription.
  ## 
  let valid = call_568079.validator(path, query, header, formData, body)
  let scheme = call_568079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568079.url(scheme.get, call_568079.host, call_568079.base,
                         call_568079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568079, url, valid)

proc call*(call_568150: Call_AppServicePlansList_567879; apiVersion: string;
          subscriptionId: string; detailed: bool = false): Recallable =
  ## appServicePlansList
  ## Get all App Service plans for a subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   detailed: bool
  ##           : Specify <code>true</code> to return all App Service plan properties. The default is <code>false</code>, which returns a subset of the properties.
  ##  Retrieval of all properties may increase the API latency.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568151 = newJObject()
  var query_568153 = newJObject()
  add(query_568153, "api-version", newJString(apiVersion))
  add(query_568153, "detailed", newJBool(detailed))
  add(path_568151, "subscriptionId", newJString(subscriptionId))
  result = call_568150.call(path_568151, query_568153, nil, nil, nil)

var appServicePlansList* = Call_AppServicePlansList_567879(
    name: "appServicePlansList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/serverfarms",
    validator: validate_AppServicePlansList_567880, base: "",
    url: url_AppServicePlansList_567881, schemes: {Scheme.Https})
type
  Call_AppServicePlansListByResourceGroup_568192 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansListByResourceGroup_568194(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansListByResourceGroup_568193(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all App Service plans in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568195 = path.getOrDefault("resourceGroupName")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "resourceGroupName", valid_568195
  var valid_568196 = path.getOrDefault("subscriptionId")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "subscriptionId", valid_568196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568197 = query.getOrDefault("api-version")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "api-version", valid_568197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568198: Call_AppServicePlansListByResourceGroup_568192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all App Service plans in a resource group.
  ## 
  let valid = call_568198.validator(path, query, header, formData, body)
  let scheme = call_568198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568198.url(scheme.get, call_568198.host, call_568198.base,
                         call_568198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568198, url, valid)

proc call*(call_568199: Call_AppServicePlansListByResourceGroup_568192;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## appServicePlansListByResourceGroup
  ## Get all App Service plans in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568200 = newJObject()
  var query_568201 = newJObject()
  add(path_568200, "resourceGroupName", newJString(resourceGroupName))
  add(query_568201, "api-version", newJString(apiVersion))
  add(path_568200, "subscriptionId", newJString(subscriptionId))
  result = call_568199.call(path_568200, query_568201, nil, nil, nil)

var appServicePlansListByResourceGroup* = Call_AppServicePlansListByResourceGroup_568192(
    name: "appServicePlansListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms",
    validator: validate_AppServicePlansListByResourceGroup_568193, base: "",
    url: url_AppServicePlansListByResourceGroup_568194, schemes: {Scheme.Https})
type
  Call_AppServicePlansCreateOrUpdate_568213 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansCreateOrUpdate_568215(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansCreateOrUpdate_568214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an App Service Plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568216 = path.getOrDefault("resourceGroupName")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "resourceGroupName", valid_568216
  var valid_568217 = path.getOrDefault("name")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "name", valid_568217
  var valid_568218 = path.getOrDefault("subscriptionId")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "subscriptionId", valid_568218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568219 = query.getOrDefault("api-version")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "api-version", valid_568219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   appServicePlan: JObject (required)
  ##                 : Details of the App Service plan.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568221: Call_AppServicePlansCreateOrUpdate_568213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an App Service Plan.
  ## 
  let valid = call_568221.validator(path, query, header, formData, body)
  let scheme = call_568221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568221.url(scheme.get, call_568221.host, call_568221.base,
                         call_568221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568221, url, valid)

proc call*(call_568222: Call_AppServicePlansCreateOrUpdate_568213;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; appServicePlan: JsonNode): Recallable =
  ## appServicePlansCreateOrUpdate
  ## Creates or updates an App Service Plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   appServicePlan: JObject (required)
  ##                 : Details of the App Service plan.
  var path_568223 = newJObject()
  var query_568224 = newJObject()
  var body_568225 = newJObject()
  add(path_568223, "resourceGroupName", newJString(resourceGroupName))
  add(query_568224, "api-version", newJString(apiVersion))
  add(path_568223, "name", newJString(name))
  add(path_568223, "subscriptionId", newJString(subscriptionId))
  if appServicePlan != nil:
    body_568225 = appServicePlan
  result = call_568222.call(path_568223, query_568224, nil, nil, body_568225)

var appServicePlansCreateOrUpdate* = Call_AppServicePlansCreateOrUpdate_568213(
    name: "appServicePlansCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}",
    validator: validate_AppServicePlansCreateOrUpdate_568214, base: "",
    url: url_AppServicePlansCreateOrUpdate_568215, schemes: {Scheme.Https})
type
  Call_AppServicePlansGet_568202 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansGet_568204(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansGet_568203(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568205 = path.getOrDefault("resourceGroupName")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "resourceGroupName", valid_568205
  var valid_568206 = path.getOrDefault("name")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "name", valid_568206
  var valid_568207 = path.getOrDefault("subscriptionId")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "subscriptionId", valid_568207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568208 = query.getOrDefault("api-version")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "api-version", valid_568208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568209: Call_AppServicePlansGet_568202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an App Service plan.
  ## 
  let valid = call_568209.validator(path, query, header, formData, body)
  let scheme = call_568209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568209.url(scheme.get, call_568209.host, call_568209.base,
                         call_568209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568209, url, valid)

proc call*(call_568210: Call_AppServicePlansGet_568202; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string): Recallable =
  ## appServicePlansGet
  ## Get an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568211 = newJObject()
  var query_568212 = newJObject()
  add(path_568211, "resourceGroupName", newJString(resourceGroupName))
  add(query_568212, "api-version", newJString(apiVersion))
  add(path_568211, "name", newJString(name))
  add(path_568211, "subscriptionId", newJString(subscriptionId))
  result = call_568210.call(path_568211, query_568212, nil, nil, nil)

var appServicePlansGet* = Call_AppServicePlansGet_568202(
    name: "appServicePlansGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}",
    validator: validate_AppServicePlansGet_568203, base: "",
    url: url_AppServicePlansGet_568204, schemes: {Scheme.Https})
type
  Call_AppServicePlansUpdate_568237 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansUpdate_568239(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansUpdate_568238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an App Service Plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568240 = path.getOrDefault("resourceGroupName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceGroupName", valid_568240
  var valid_568241 = path.getOrDefault("name")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "name", valid_568241
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "api-version", valid_568243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   appServicePlan: JObject (required)
  ##                 : Details of the App Service plan.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568245: Call_AppServicePlansUpdate_568237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an App Service Plan.
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_AppServicePlansUpdate_568237;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; appServicePlan: JsonNode): Recallable =
  ## appServicePlansUpdate
  ## Creates or updates an App Service Plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   appServicePlan: JObject (required)
  ##                 : Details of the App Service plan.
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  var body_568249 = newJObject()
  add(path_568247, "resourceGroupName", newJString(resourceGroupName))
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "name", newJString(name))
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  if appServicePlan != nil:
    body_568249 = appServicePlan
  result = call_568246.call(path_568247, query_568248, nil, nil, body_568249)

var appServicePlansUpdate* = Call_AppServicePlansUpdate_568237(
    name: "appServicePlansUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}",
    validator: validate_AppServicePlansUpdate_568238, base: "",
    url: url_AppServicePlansUpdate_568239, schemes: {Scheme.Https})
type
  Call_AppServicePlansDelete_568226 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansDelete_568228(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansDelete_568227(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568229 = path.getOrDefault("resourceGroupName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "resourceGroupName", valid_568229
  var valid_568230 = path.getOrDefault("name")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "name", valid_568230
  var valid_568231 = path.getOrDefault("subscriptionId")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "subscriptionId", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568232 = query.getOrDefault("api-version")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "api-version", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_AppServicePlansDelete_568226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an App Service plan.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_AppServicePlansDelete_568226;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServicePlansDelete
  ## Delete an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(path_568235, "resourceGroupName", newJString(resourceGroupName))
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "name", newJString(name))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var appServicePlansDelete* = Call_AppServicePlansDelete_568226(
    name: "appServicePlansDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}",
    validator: validate_AppServicePlansDelete_568227, base: "",
    url: url_AppServicePlansDelete_568228, schemes: {Scheme.Https})
type
  Call_AppServicePlansListCapabilities_568250 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansListCapabilities_568252(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/capabilities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansListCapabilities_568251(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all capabilities of an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568253 = path.getOrDefault("resourceGroupName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "resourceGroupName", valid_568253
  var valid_568254 = path.getOrDefault("name")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "name", valid_568254
  var valid_568255 = path.getOrDefault("subscriptionId")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "subscriptionId", valid_568255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568256 = query.getOrDefault("api-version")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "api-version", valid_568256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568257: Call_AppServicePlansListCapabilities_568250;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all capabilities of an App Service plan.
  ## 
  let valid = call_568257.validator(path, query, header, formData, body)
  let scheme = call_568257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568257.url(scheme.get, call_568257.host, call_568257.base,
                         call_568257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568257, url, valid)

proc call*(call_568258: Call_AppServicePlansListCapabilities_568250;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServicePlansListCapabilities
  ## List all capabilities of an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568259 = newJObject()
  var query_568260 = newJObject()
  add(path_568259, "resourceGroupName", newJString(resourceGroupName))
  add(query_568260, "api-version", newJString(apiVersion))
  add(path_568259, "name", newJString(name))
  add(path_568259, "subscriptionId", newJString(subscriptionId))
  result = call_568258.call(path_568259, query_568260, nil, nil, nil)

var appServicePlansListCapabilities* = Call_AppServicePlansListCapabilities_568250(
    name: "appServicePlansListCapabilities", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/capabilities",
    validator: validate_AppServicePlansListCapabilities_568251, base: "",
    url: url_AppServicePlansListCapabilities_568252, schemes: {Scheme.Https})
type
  Call_AppServicePlansGetHybridConnection_568261 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansGetHybridConnection_568263(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "relayName" in path, "`relayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/hybridConnectionNamespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/relays/"),
               (kind: VariableSegment, value: "relayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansGetHybridConnection_568262(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a Hybrid Connection in use in an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : Name of the Service Bus namespace.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   relayName: JString (required)
  ##            : Name of the Service Bus relay.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568264 = path.getOrDefault("namespaceName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "namespaceName", valid_568264
  var valid_568265 = path.getOrDefault("resourceGroupName")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "resourceGroupName", valid_568265
  var valid_568266 = path.getOrDefault("name")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "name", valid_568266
  var valid_568267 = path.getOrDefault("subscriptionId")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "subscriptionId", valid_568267
  var valid_568268 = path.getOrDefault("relayName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "relayName", valid_568268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568269 = query.getOrDefault("api-version")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "api-version", valid_568269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568270: Call_AppServicePlansGetHybridConnection_568261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a Hybrid Connection in use in an App Service plan.
  ## 
  let valid = call_568270.validator(path, query, header, formData, body)
  let scheme = call_568270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568270.url(scheme.get, call_568270.host, call_568270.base,
                         call_568270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568270, url, valid)

proc call*(call_568271: Call_AppServicePlansGetHybridConnection_568261;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          name: string; subscriptionId: string; relayName: string): Recallable =
  ## appServicePlansGetHybridConnection
  ## Retrieve a Hybrid Connection in use in an App Service plan.
  ##   namespaceName: string (required)
  ##                : Name of the Service Bus namespace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   relayName: string (required)
  ##            : Name of the Service Bus relay.
  var path_568272 = newJObject()
  var query_568273 = newJObject()
  add(path_568272, "namespaceName", newJString(namespaceName))
  add(path_568272, "resourceGroupName", newJString(resourceGroupName))
  add(query_568273, "api-version", newJString(apiVersion))
  add(path_568272, "name", newJString(name))
  add(path_568272, "subscriptionId", newJString(subscriptionId))
  add(path_568272, "relayName", newJString(relayName))
  result = call_568271.call(path_568272, query_568273, nil, nil, nil)

var appServicePlansGetHybridConnection* = Call_AppServicePlansGetHybridConnection_568261(
    name: "appServicePlansGetHybridConnection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/hybridConnectionNamespaces/{namespaceName}/relays/{relayName}",
    validator: validate_AppServicePlansGetHybridConnection_568262, base: "",
    url: url_AppServicePlansGetHybridConnection_568263, schemes: {Scheme.Https})
type
  Call_AppServicePlansDeleteHybridConnection_568274 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansDeleteHybridConnection_568276(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "relayName" in path, "`relayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/hybridConnectionNamespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/relays/"),
               (kind: VariableSegment, value: "relayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansDeleteHybridConnection_568275(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Hybrid Connection in use in an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : Name of the Service Bus namespace.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   relayName: JString (required)
  ##            : Name of the Service Bus relay.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568277 = path.getOrDefault("namespaceName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "namespaceName", valid_568277
  var valid_568278 = path.getOrDefault("resourceGroupName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "resourceGroupName", valid_568278
  var valid_568279 = path.getOrDefault("name")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "name", valid_568279
  var valid_568280 = path.getOrDefault("subscriptionId")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "subscriptionId", valid_568280
  var valid_568281 = path.getOrDefault("relayName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "relayName", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "api-version", valid_568282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_AppServicePlansDeleteHybridConnection_568274;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a Hybrid Connection in use in an App Service plan.
  ## 
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_AppServicePlansDeleteHybridConnection_568274;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          name: string; subscriptionId: string; relayName: string): Recallable =
  ## appServicePlansDeleteHybridConnection
  ## Delete a Hybrid Connection in use in an App Service plan.
  ##   namespaceName: string (required)
  ##                : Name of the Service Bus namespace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   relayName: string (required)
  ##            : Name of the Service Bus relay.
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  add(path_568285, "namespaceName", newJString(namespaceName))
  add(path_568285, "resourceGroupName", newJString(resourceGroupName))
  add(query_568286, "api-version", newJString(apiVersion))
  add(path_568285, "name", newJString(name))
  add(path_568285, "subscriptionId", newJString(subscriptionId))
  add(path_568285, "relayName", newJString(relayName))
  result = call_568284.call(path_568285, query_568286, nil, nil, nil)

var appServicePlansDeleteHybridConnection* = Call_AppServicePlansDeleteHybridConnection_568274(
    name: "appServicePlansDeleteHybridConnection", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/hybridConnectionNamespaces/{namespaceName}/relays/{relayName}",
    validator: validate_AppServicePlansDeleteHybridConnection_568275, base: "",
    url: url_AppServicePlansDeleteHybridConnection_568276, schemes: {Scheme.Https})
type
  Call_AppServicePlansListHybridConnectionKeys_568287 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansListHybridConnectionKeys_568289(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "relayName" in path, "`relayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/hybridConnectionNamespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/relays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansListHybridConnectionKeys_568288(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the send key name and value of a Hybrid Connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The name of the Service Bus namespace.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   relayName: JString (required)
  ##            : The name of the Service Bus relay.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568290 = path.getOrDefault("namespaceName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "namespaceName", valid_568290
  var valid_568291 = path.getOrDefault("resourceGroupName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "resourceGroupName", valid_568291
  var valid_568292 = path.getOrDefault("name")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "name", valid_568292
  var valid_568293 = path.getOrDefault("subscriptionId")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "subscriptionId", valid_568293
  var valid_568294 = path.getOrDefault("relayName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "relayName", valid_568294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568295 = query.getOrDefault("api-version")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "api-version", valid_568295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568296: Call_AppServicePlansListHybridConnectionKeys_568287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the send key name and value of a Hybrid Connection.
  ## 
  let valid = call_568296.validator(path, query, header, formData, body)
  let scheme = call_568296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568296.url(scheme.get, call_568296.host, call_568296.base,
                         call_568296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568296, url, valid)

proc call*(call_568297: Call_AppServicePlansListHybridConnectionKeys_568287;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          name: string; subscriptionId: string; relayName: string): Recallable =
  ## appServicePlansListHybridConnectionKeys
  ## Get the send key name and value of a Hybrid Connection.
  ##   namespaceName: string (required)
  ##                : The name of the Service Bus namespace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   relayName: string (required)
  ##            : The name of the Service Bus relay.
  var path_568298 = newJObject()
  var query_568299 = newJObject()
  add(path_568298, "namespaceName", newJString(namespaceName))
  add(path_568298, "resourceGroupName", newJString(resourceGroupName))
  add(query_568299, "api-version", newJString(apiVersion))
  add(path_568298, "name", newJString(name))
  add(path_568298, "subscriptionId", newJString(subscriptionId))
  add(path_568298, "relayName", newJString(relayName))
  result = call_568297.call(path_568298, query_568299, nil, nil, nil)

var appServicePlansListHybridConnectionKeys* = Call_AppServicePlansListHybridConnectionKeys_568287(
    name: "appServicePlansListHybridConnectionKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/hybridConnectionNamespaces/{namespaceName}/relays/{relayName}/listKeys",
    validator: validate_AppServicePlansListHybridConnectionKeys_568288, base: "",
    url: url_AppServicePlansListHybridConnectionKeys_568289,
    schemes: {Scheme.Https})
type
  Call_AppServicePlansListWebAppsByHybridConnection_568300 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansListWebAppsByHybridConnection_568302(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "relayName" in path, "`relayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/hybridConnectionNamespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/relays/"),
               (kind: VariableSegment, value: "relayName"),
               (kind: ConstantSegment, value: "/sites")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansListWebAppsByHybridConnection_568301(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all apps that use a Hybrid Connection in an App Service Plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : Name of the Hybrid Connection namespace.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   relayName: JString (required)
  ##            : Name of the Hybrid Connection relay.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568303 = path.getOrDefault("namespaceName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "namespaceName", valid_568303
  var valid_568304 = path.getOrDefault("resourceGroupName")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "resourceGroupName", valid_568304
  var valid_568305 = path.getOrDefault("name")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "name", valid_568305
  var valid_568306 = path.getOrDefault("subscriptionId")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "subscriptionId", valid_568306
  var valid_568307 = path.getOrDefault("relayName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "relayName", valid_568307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568308 = query.getOrDefault("api-version")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "api-version", valid_568308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568309: Call_AppServicePlansListWebAppsByHybridConnection_568300;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all apps that use a Hybrid Connection in an App Service Plan.
  ## 
  let valid = call_568309.validator(path, query, header, formData, body)
  let scheme = call_568309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568309.url(scheme.get, call_568309.host, call_568309.base,
                         call_568309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568309, url, valid)

proc call*(call_568310: Call_AppServicePlansListWebAppsByHybridConnection_568300;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          name: string; subscriptionId: string; relayName: string): Recallable =
  ## appServicePlansListWebAppsByHybridConnection
  ## Get all apps that use a Hybrid Connection in an App Service Plan.
  ##   namespaceName: string (required)
  ##                : Name of the Hybrid Connection namespace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   relayName: string (required)
  ##            : Name of the Hybrid Connection relay.
  var path_568311 = newJObject()
  var query_568312 = newJObject()
  add(path_568311, "namespaceName", newJString(namespaceName))
  add(path_568311, "resourceGroupName", newJString(resourceGroupName))
  add(query_568312, "api-version", newJString(apiVersion))
  add(path_568311, "name", newJString(name))
  add(path_568311, "subscriptionId", newJString(subscriptionId))
  add(path_568311, "relayName", newJString(relayName))
  result = call_568310.call(path_568311, query_568312, nil, nil, nil)

var appServicePlansListWebAppsByHybridConnection* = Call_AppServicePlansListWebAppsByHybridConnection_568300(
    name: "appServicePlansListWebAppsByHybridConnection",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/hybridConnectionNamespaces/{namespaceName}/relays/{relayName}/sites",
    validator: validate_AppServicePlansListWebAppsByHybridConnection_568301,
    base: "", url: url_AppServicePlansListWebAppsByHybridConnection_568302,
    schemes: {Scheme.Https})
type
  Call_AppServicePlansGetHybridConnectionPlanLimit_568313 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansGetHybridConnectionPlanLimit_568315(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"), (kind: ConstantSegment,
        value: "/hybridConnectionPlanLimits/limit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansGetHybridConnectionPlanLimit_568314(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the maximum number of Hybrid Connections allowed in an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568316 = path.getOrDefault("resourceGroupName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "resourceGroupName", valid_568316
  var valid_568317 = path.getOrDefault("name")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "name", valid_568317
  var valid_568318 = path.getOrDefault("subscriptionId")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "subscriptionId", valid_568318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568319 = query.getOrDefault("api-version")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "api-version", valid_568319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568320: Call_AppServicePlansGetHybridConnectionPlanLimit_568313;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the maximum number of Hybrid Connections allowed in an App Service plan.
  ## 
  let valid = call_568320.validator(path, query, header, formData, body)
  let scheme = call_568320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568320.url(scheme.get, call_568320.host, call_568320.base,
                         call_568320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568320, url, valid)

proc call*(call_568321: Call_AppServicePlansGetHybridConnectionPlanLimit_568313;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServicePlansGetHybridConnectionPlanLimit
  ## Get the maximum number of Hybrid Connections allowed in an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568322 = newJObject()
  var query_568323 = newJObject()
  add(path_568322, "resourceGroupName", newJString(resourceGroupName))
  add(query_568323, "api-version", newJString(apiVersion))
  add(path_568322, "name", newJString(name))
  add(path_568322, "subscriptionId", newJString(subscriptionId))
  result = call_568321.call(path_568322, query_568323, nil, nil, nil)

var appServicePlansGetHybridConnectionPlanLimit* = Call_AppServicePlansGetHybridConnectionPlanLimit_568313(
    name: "appServicePlansGetHybridConnectionPlanLimit", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/hybridConnectionPlanLimits/limit",
    validator: validate_AppServicePlansGetHybridConnectionPlanLimit_568314,
    base: "", url: url_AppServicePlansGetHybridConnectionPlanLimit_568315,
    schemes: {Scheme.Https})
type
  Call_AppServicePlansListHybridConnections_568324 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansListHybridConnections_568326(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/hybridConnectionRelays")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansListHybridConnections_568325(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve all Hybrid Connections in use in an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568327 = path.getOrDefault("resourceGroupName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "resourceGroupName", valid_568327
  var valid_568328 = path.getOrDefault("name")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "name", valid_568328
  var valid_568329 = path.getOrDefault("subscriptionId")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "subscriptionId", valid_568329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568330 = query.getOrDefault("api-version")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "api-version", valid_568330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568331: Call_AppServicePlansListHybridConnections_568324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve all Hybrid Connections in use in an App Service plan.
  ## 
  let valid = call_568331.validator(path, query, header, formData, body)
  let scheme = call_568331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568331.url(scheme.get, call_568331.host, call_568331.base,
                         call_568331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568331, url, valid)

proc call*(call_568332: Call_AppServicePlansListHybridConnections_568324;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServicePlansListHybridConnections
  ## Retrieve all Hybrid Connections in use in an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568333 = newJObject()
  var query_568334 = newJObject()
  add(path_568333, "resourceGroupName", newJString(resourceGroupName))
  add(query_568334, "api-version", newJString(apiVersion))
  add(path_568333, "name", newJString(name))
  add(path_568333, "subscriptionId", newJString(subscriptionId))
  result = call_568332.call(path_568333, query_568334, nil, nil, nil)

var appServicePlansListHybridConnections* = Call_AppServicePlansListHybridConnections_568324(
    name: "appServicePlansListHybridConnections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/hybridConnectionRelays",
    validator: validate_AppServicePlansListHybridConnections_568325, base: "",
    url: url_AppServicePlansListHybridConnections_568326, schemes: {Scheme.Https})
type
  Call_AppServicePlansListMetricDefintions_568335 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansListMetricDefintions_568337(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/metricdefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansListMetricDefintions_568336(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get metrics that can be queried for an App Service plan, and their definitions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568338 = path.getOrDefault("resourceGroupName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "resourceGroupName", valid_568338
  var valid_568339 = path.getOrDefault("name")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "name", valid_568339
  var valid_568340 = path.getOrDefault("subscriptionId")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "subscriptionId", valid_568340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568341 = query.getOrDefault("api-version")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "api-version", valid_568341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568342: Call_AppServicePlansListMetricDefintions_568335;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics that can be queried for an App Service plan, and their definitions.
  ## 
  let valid = call_568342.validator(path, query, header, formData, body)
  let scheme = call_568342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568342.url(scheme.get, call_568342.host, call_568342.base,
                         call_568342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568342, url, valid)

proc call*(call_568343: Call_AppServicePlansListMetricDefintions_568335;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServicePlansListMetricDefintions
  ## Get metrics that can be queried for an App Service plan, and their definitions.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568344 = newJObject()
  var query_568345 = newJObject()
  add(path_568344, "resourceGroupName", newJString(resourceGroupName))
  add(query_568345, "api-version", newJString(apiVersion))
  add(path_568344, "name", newJString(name))
  add(path_568344, "subscriptionId", newJString(subscriptionId))
  result = call_568343.call(path_568344, query_568345, nil, nil, nil)

var appServicePlansListMetricDefintions* = Call_AppServicePlansListMetricDefintions_568335(
    name: "appServicePlansListMetricDefintions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/metricdefinitions",
    validator: validate_AppServicePlansListMetricDefintions_568336, base: "",
    url: url_AppServicePlansListMetricDefintions_568337, schemes: {Scheme.Https})
type
  Call_AppServicePlansListMetrics_568346 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansListMetrics_568348(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansListMetrics_568347(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get metrics for an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568350 = path.getOrDefault("resourceGroupName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "resourceGroupName", valid_568350
  var valid_568351 = path.getOrDefault("name")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "name", valid_568351
  var valid_568352 = path.getOrDefault("subscriptionId")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "subscriptionId", valid_568352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568353 = query.getOrDefault("api-version")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "api-version", valid_568353
  var valid_568354 = query.getOrDefault("details")
  valid_568354 = validateParameter(valid_568354, JBool, required = false, default = nil)
  if valid_568354 != nil:
    section.add "details", valid_568354
  var valid_568355 = query.getOrDefault("$filter")
  valid_568355 = validateParameter(valid_568355, JString, required = false,
                                 default = nil)
  if valid_568355 != nil:
    section.add "$filter", valid_568355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568356: Call_AppServicePlansListMetrics_568346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get metrics for an App Service plan.
  ## 
  let valid = call_568356.validator(path, query, header, formData, body)
  let scheme = call_568356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568356.url(scheme.get, call_568356.host, call_568356.base,
                         call_568356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568356, url, valid)

proc call*(call_568357: Call_AppServicePlansListMetrics_568346;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; details: bool = false; Filter: string = ""): Recallable =
  ## appServicePlansListMetrics
  ## Get metrics for an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq '2014-01-01T00:00:00Z' and endTime eq '2014-12-31T23:59:59Z' and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_568358 = newJObject()
  var query_568359 = newJObject()
  add(path_568358, "resourceGroupName", newJString(resourceGroupName))
  add(query_568359, "api-version", newJString(apiVersion))
  add(path_568358, "name", newJString(name))
  add(query_568359, "details", newJBool(details))
  add(path_568358, "subscriptionId", newJString(subscriptionId))
  add(query_568359, "$filter", newJString(Filter))
  result = call_568357.call(path_568358, query_568359, nil, nil, nil)

var appServicePlansListMetrics* = Call_AppServicePlansListMetrics_568346(
    name: "appServicePlansListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/metrics",
    validator: validate_AppServicePlansListMetrics_568347, base: "",
    url: url_AppServicePlansListMetrics_568348, schemes: {Scheme.Https})
type
  Call_AppServicePlansRestartWebApps_568360 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansRestartWebApps_568362(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/restartSites")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansRestartWebApps_568361(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restart all apps in an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568363 = path.getOrDefault("resourceGroupName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "resourceGroupName", valid_568363
  var valid_568364 = path.getOrDefault("name")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "name", valid_568364
  var valid_568365 = path.getOrDefault("subscriptionId")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "subscriptionId", valid_568365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   softRestart: JBool
  ##              : Specify <code>true</code> to perform a soft restart, applies the configuration settings and restarts the apps if necessary. The default is <code>false</code>, which always restarts and reprovisions the apps
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "api-version", valid_568366
  var valid_568367 = query.getOrDefault("softRestart")
  valid_568367 = validateParameter(valid_568367, JBool, required = false, default = nil)
  if valid_568367 != nil:
    section.add "softRestart", valid_568367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568368: Call_AppServicePlansRestartWebApps_568360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restart all apps in an App Service plan.
  ## 
  let valid = call_568368.validator(path, query, header, formData, body)
  let scheme = call_568368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568368.url(scheme.get, call_568368.host, call_568368.base,
                         call_568368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568368, url, valid)

proc call*(call_568369: Call_AppServicePlansRestartWebApps_568360;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; softRestart: bool = false): Recallable =
  ## appServicePlansRestartWebApps
  ## Restart all apps in an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   softRestart: bool
  ##              : Specify <code>true</code> to perform a soft restart, applies the configuration settings and restarts the apps if necessary. The default is <code>false</code>, which always restarts and reprovisions the apps
  var path_568370 = newJObject()
  var query_568371 = newJObject()
  add(path_568370, "resourceGroupName", newJString(resourceGroupName))
  add(query_568371, "api-version", newJString(apiVersion))
  add(path_568370, "name", newJString(name))
  add(path_568370, "subscriptionId", newJString(subscriptionId))
  add(query_568371, "softRestart", newJBool(softRestart))
  result = call_568369.call(path_568370, query_568371, nil, nil, nil)

var appServicePlansRestartWebApps* = Call_AppServicePlansRestartWebApps_568360(
    name: "appServicePlansRestartWebApps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/restartSites",
    validator: validate_AppServicePlansRestartWebApps_568361, base: "",
    url: url_AppServicePlansRestartWebApps_568362, schemes: {Scheme.Https})
type
  Call_AppServicePlansListWebApps_568372 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansListWebApps_568374(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/sites")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansListWebApps_568373(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all apps associated with an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568375 = path.getOrDefault("resourceGroupName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "resourceGroupName", valid_568375
  var valid_568376 = path.getOrDefault("name")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "name", valid_568376
  var valid_568377 = path.getOrDefault("subscriptionId")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "subscriptionId", valid_568377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   $top: JString
  ##       : List page size. If specified, results are paged.
  ##   $skipToken: JString
  ##             : Skip to a web app in the list of webapps associated with app service plan. If specified, the resulting list will contain web apps starting from (including) the skipToken. Otherwise, the resulting list contains web apps from the start of the list
  ##   $filter: JString
  ##          : Supported filter: $filter=state eq running. Returns only web apps that are currently running
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568378 = query.getOrDefault("api-version")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "api-version", valid_568378
  var valid_568379 = query.getOrDefault("$top")
  valid_568379 = validateParameter(valid_568379, JString, required = false,
                                 default = nil)
  if valid_568379 != nil:
    section.add "$top", valid_568379
  var valid_568380 = query.getOrDefault("$skipToken")
  valid_568380 = validateParameter(valid_568380, JString, required = false,
                                 default = nil)
  if valid_568380 != nil:
    section.add "$skipToken", valid_568380
  var valid_568381 = query.getOrDefault("$filter")
  valid_568381 = validateParameter(valid_568381, JString, required = false,
                                 default = nil)
  if valid_568381 != nil:
    section.add "$filter", valid_568381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568382: Call_AppServicePlansListWebApps_568372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all apps associated with an App Service plan.
  ## 
  let valid = call_568382.validator(path, query, header, formData, body)
  let scheme = call_568382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568382.url(scheme.get, call_568382.host, call_568382.base,
                         call_568382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568382, url, valid)

proc call*(call_568383: Call_AppServicePlansListWebApps_568372;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; Top: string = ""; SkipToken: string = "";
          Filter: string = ""): Recallable =
  ## appServicePlansListWebApps
  ## Get all apps associated with an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   Top: string
  ##      : List page size. If specified, results are paged.
  ##   SkipToken: string
  ##            : Skip to a web app in the list of webapps associated with app service plan. If specified, the resulting list will contain web apps starting from (including) the skipToken. Otherwise, the resulting list contains web apps from the start of the list
  ##   Filter: string
  ##         : Supported filter: $filter=state eq running. Returns only web apps that are currently running
  var path_568384 = newJObject()
  var query_568385 = newJObject()
  add(path_568384, "resourceGroupName", newJString(resourceGroupName))
  add(query_568385, "api-version", newJString(apiVersion))
  add(path_568384, "name", newJString(name))
  add(path_568384, "subscriptionId", newJString(subscriptionId))
  add(query_568385, "$top", newJString(Top))
  add(query_568385, "$skipToken", newJString(SkipToken))
  add(query_568385, "$filter", newJString(Filter))
  result = call_568383.call(path_568384, query_568385, nil, nil, nil)

var appServicePlansListWebApps* = Call_AppServicePlansListWebApps_568372(
    name: "appServicePlansListWebApps", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/sites",
    validator: validate_AppServicePlansListWebApps_568373, base: "",
    url: url_AppServicePlansListWebApps_568374, schemes: {Scheme.Https})
type
  Call_AppServicePlansGetServerFarmSkus_568386 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansGetServerFarmSkus_568388(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansGetServerFarmSkus_568387(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all selectable SKUs for a given App Service Plan
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of App Service Plan
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568389 = path.getOrDefault("resourceGroupName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "resourceGroupName", valid_568389
  var valid_568390 = path.getOrDefault("name")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "name", valid_568390
  var valid_568391 = path.getOrDefault("subscriptionId")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "subscriptionId", valid_568391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568392 = query.getOrDefault("api-version")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "api-version", valid_568392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568393: Call_AppServicePlansGetServerFarmSkus_568386;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all selectable SKUs for a given App Service Plan
  ## 
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_AppServicePlansGetServerFarmSkus_568386;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServicePlansGetServerFarmSkus
  ## Gets all selectable SKUs for a given App Service Plan
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of App Service Plan
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568395 = newJObject()
  var query_568396 = newJObject()
  add(path_568395, "resourceGroupName", newJString(resourceGroupName))
  add(query_568396, "api-version", newJString(apiVersion))
  add(path_568395, "name", newJString(name))
  add(path_568395, "subscriptionId", newJString(subscriptionId))
  result = call_568394.call(path_568395, query_568396, nil, nil, nil)

var appServicePlansGetServerFarmSkus* = Call_AppServicePlansGetServerFarmSkus_568386(
    name: "appServicePlansGetServerFarmSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/skus",
    validator: validate_AppServicePlansGetServerFarmSkus_568387, base: "",
    url: url_AppServicePlansGetServerFarmSkus_568388, schemes: {Scheme.Https})
type
  Call_AppServicePlansListUsages_568397 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansListUsages_568399(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansListUsages_568398(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets server farm usage information
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of App Service Plan
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568400 = path.getOrDefault("resourceGroupName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "resourceGroupName", valid_568400
  var valid_568401 = path.getOrDefault("name")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "name", valid_568401
  var valid_568402 = path.getOrDefault("subscriptionId")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "subscriptionId", valid_568402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2').
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568403 = query.getOrDefault("api-version")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "api-version", valid_568403
  var valid_568404 = query.getOrDefault("$filter")
  valid_568404 = validateParameter(valid_568404, JString, required = false,
                                 default = nil)
  if valid_568404 != nil:
    section.add "$filter", valid_568404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568405: Call_AppServicePlansListUsages_568397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets server farm usage information
  ## 
  let valid = call_568405.validator(path, query, header, formData, body)
  let scheme = call_568405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568405.url(scheme.get, call_568405.host, call_568405.base,
                         call_568405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568405, url, valid)

proc call*(call_568406: Call_AppServicePlansListUsages_568397;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## appServicePlansListUsages
  ## Gets server farm usage information
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of App Service Plan
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2').
  var path_568407 = newJObject()
  var query_568408 = newJObject()
  add(path_568407, "resourceGroupName", newJString(resourceGroupName))
  add(query_568408, "api-version", newJString(apiVersion))
  add(path_568407, "name", newJString(name))
  add(path_568407, "subscriptionId", newJString(subscriptionId))
  add(query_568408, "$filter", newJString(Filter))
  result = call_568406.call(path_568407, query_568408, nil, nil, nil)

var appServicePlansListUsages* = Call_AppServicePlansListUsages_568397(
    name: "appServicePlansListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/usages",
    validator: validate_AppServicePlansListUsages_568398, base: "",
    url: url_AppServicePlansListUsages_568399, schemes: {Scheme.Https})
type
  Call_AppServicePlansListVnets_568409 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansListVnets_568411(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/virtualNetworkConnections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansListVnets_568410(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all Virtual Networks associated with an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568412 = path.getOrDefault("resourceGroupName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "resourceGroupName", valid_568412
  var valid_568413 = path.getOrDefault("name")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "name", valid_568413
  var valid_568414 = path.getOrDefault("subscriptionId")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "subscriptionId", valid_568414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568415 = query.getOrDefault("api-version")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "api-version", valid_568415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568416: Call_AppServicePlansListVnets_568409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Virtual Networks associated with an App Service plan.
  ## 
  let valid = call_568416.validator(path, query, header, formData, body)
  let scheme = call_568416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568416.url(scheme.get, call_568416.host, call_568416.base,
                         call_568416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568416, url, valid)

proc call*(call_568417: Call_AppServicePlansListVnets_568409;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServicePlansListVnets
  ## Get all Virtual Networks associated with an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568418 = newJObject()
  var query_568419 = newJObject()
  add(path_568418, "resourceGroupName", newJString(resourceGroupName))
  add(query_568419, "api-version", newJString(apiVersion))
  add(path_568418, "name", newJString(name))
  add(path_568418, "subscriptionId", newJString(subscriptionId))
  result = call_568417.call(path_568418, query_568419, nil, nil, nil)

var appServicePlansListVnets* = Call_AppServicePlansListVnets_568409(
    name: "appServicePlansListVnets", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections",
    validator: validate_AppServicePlansListVnets_568410, base: "",
    url: url_AppServicePlansListVnets_568411, schemes: {Scheme.Https})
type
  Call_AppServicePlansGetVnetFromServerFarm_568420 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansGetVnetFromServerFarm_568422(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "vnetName" in path, "`vnetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/virtualNetworkConnections/"),
               (kind: VariableSegment, value: "vnetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansGetVnetFromServerFarm_568421(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Virtual Network associated with an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   vnetName: JString (required)
  ##           : Name of the Virtual Network.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568423 = path.getOrDefault("resourceGroupName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "resourceGroupName", valid_568423
  var valid_568424 = path.getOrDefault("name")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "name", valid_568424
  var valid_568425 = path.getOrDefault("vnetName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "vnetName", valid_568425
  var valid_568426 = path.getOrDefault("subscriptionId")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "subscriptionId", valid_568426
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568427 = query.getOrDefault("api-version")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "api-version", valid_568427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568428: Call_AppServicePlansGetVnetFromServerFarm_568420;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a Virtual Network associated with an App Service plan.
  ## 
  let valid = call_568428.validator(path, query, header, formData, body)
  let scheme = call_568428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568428.url(scheme.get, call_568428.host, call_568428.base,
                         call_568428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568428, url, valid)

proc call*(call_568429: Call_AppServicePlansGetVnetFromServerFarm_568420;
          resourceGroupName: string; apiVersion: string; name: string;
          vnetName: string; subscriptionId: string): Recallable =
  ## appServicePlansGetVnetFromServerFarm
  ## Get a Virtual Network associated with an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   vnetName: string (required)
  ##           : Name of the Virtual Network.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568430 = newJObject()
  var query_568431 = newJObject()
  add(path_568430, "resourceGroupName", newJString(resourceGroupName))
  add(query_568431, "api-version", newJString(apiVersion))
  add(path_568430, "name", newJString(name))
  add(path_568430, "vnetName", newJString(vnetName))
  add(path_568430, "subscriptionId", newJString(subscriptionId))
  result = call_568429.call(path_568430, query_568431, nil, nil, nil)

var appServicePlansGetVnetFromServerFarm* = Call_AppServicePlansGetVnetFromServerFarm_568420(
    name: "appServicePlansGetVnetFromServerFarm", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}",
    validator: validate_AppServicePlansGetVnetFromServerFarm_568421, base: "",
    url: url_AppServicePlansGetVnetFromServerFarm_568422, schemes: {Scheme.Https})
type
  Call_AppServicePlansUpdateVnetGateway_568445 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansUpdateVnetGateway_568447(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "vnetName" in path, "`vnetName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/virtualNetworkConnections/"),
               (kind: VariableSegment, value: "vnetName"),
               (kind: ConstantSegment, value: "/gateways/"),
               (kind: VariableSegment, value: "gatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansUpdateVnetGateway_568446(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a Virtual Network gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   vnetName: JString (required)
  ##           : Name of the Virtual Network.
  ##   gatewayName: JString (required)
  ##              : Name of the gateway. Only the 'primary' gateway is supported.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568448 = path.getOrDefault("resourceGroupName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "resourceGroupName", valid_568448
  var valid_568449 = path.getOrDefault("name")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "name", valid_568449
  var valid_568450 = path.getOrDefault("vnetName")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "vnetName", valid_568450
  var valid_568451 = path.getOrDefault("gatewayName")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "gatewayName", valid_568451
  var valid_568452 = path.getOrDefault("subscriptionId")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "subscriptionId", valid_568452
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568453 = query.getOrDefault("api-version")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "api-version", valid_568453
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   connectionEnvelope: JObject (required)
  ##                     : Definition of the gateway.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568455: Call_AppServicePlansUpdateVnetGateway_568445;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a Virtual Network gateway.
  ## 
  let valid = call_568455.validator(path, query, header, formData, body)
  let scheme = call_568455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568455.url(scheme.get, call_568455.host, call_568455.base,
                         call_568455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568455, url, valid)

proc call*(call_568456: Call_AppServicePlansUpdateVnetGateway_568445;
          resourceGroupName: string; connectionEnvelope: JsonNode; name: string;
          vnetName: string; apiVersion: string; gatewayName: string;
          subscriptionId: string): Recallable =
  ## appServicePlansUpdateVnetGateway
  ## Update a Virtual Network gateway.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   connectionEnvelope: JObject (required)
  ##                     : Definition of the gateway.
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   vnetName: string (required)
  ##           : Name of the Virtual Network.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   gatewayName: string (required)
  ##              : Name of the gateway. Only the 'primary' gateway is supported.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568457 = newJObject()
  var query_568458 = newJObject()
  var body_568459 = newJObject()
  add(path_568457, "resourceGroupName", newJString(resourceGroupName))
  if connectionEnvelope != nil:
    body_568459 = connectionEnvelope
  add(path_568457, "name", newJString(name))
  add(path_568457, "vnetName", newJString(vnetName))
  add(query_568458, "api-version", newJString(apiVersion))
  add(path_568457, "gatewayName", newJString(gatewayName))
  add(path_568457, "subscriptionId", newJString(subscriptionId))
  result = call_568456.call(path_568457, query_568458, nil, nil, body_568459)

var appServicePlansUpdateVnetGateway* = Call_AppServicePlansUpdateVnetGateway_568445(
    name: "appServicePlansUpdateVnetGateway", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}/gateways/{gatewayName}",
    validator: validate_AppServicePlansUpdateVnetGateway_568446, base: "",
    url: url_AppServicePlansUpdateVnetGateway_568447, schemes: {Scheme.Https})
type
  Call_AppServicePlansGetVnetGateway_568432 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansGetVnetGateway_568434(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "vnetName" in path, "`vnetName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/virtualNetworkConnections/"),
               (kind: VariableSegment, value: "vnetName"),
               (kind: ConstantSegment, value: "/gateways/"),
               (kind: VariableSegment, value: "gatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansGetVnetGateway_568433(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Virtual Network gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   vnetName: JString (required)
  ##           : Name of the Virtual Network.
  ##   gatewayName: JString (required)
  ##              : Name of the gateway. Only the 'primary' gateway is supported.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568435 = path.getOrDefault("resourceGroupName")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "resourceGroupName", valid_568435
  var valid_568436 = path.getOrDefault("name")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "name", valid_568436
  var valid_568437 = path.getOrDefault("vnetName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "vnetName", valid_568437
  var valid_568438 = path.getOrDefault("gatewayName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "gatewayName", valid_568438
  var valid_568439 = path.getOrDefault("subscriptionId")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "subscriptionId", valid_568439
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568440 = query.getOrDefault("api-version")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "api-version", valid_568440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568441: Call_AppServicePlansGetVnetGateway_568432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Virtual Network gateway.
  ## 
  let valid = call_568441.validator(path, query, header, formData, body)
  let scheme = call_568441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568441.url(scheme.get, call_568441.host, call_568441.base,
                         call_568441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568441, url, valid)

proc call*(call_568442: Call_AppServicePlansGetVnetGateway_568432;
          resourceGroupName: string; apiVersion: string; name: string;
          vnetName: string; gatewayName: string; subscriptionId: string): Recallable =
  ## appServicePlansGetVnetGateway
  ## Get a Virtual Network gateway.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   vnetName: string (required)
  ##           : Name of the Virtual Network.
  ##   gatewayName: string (required)
  ##              : Name of the gateway. Only the 'primary' gateway is supported.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568443 = newJObject()
  var query_568444 = newJObject()
  add(path_568443, "resourceGroupName", newJString(resourceGroupName))
  add(query_568444, "api-version", newJString(apiVersion))
  add(path_568443, "name", newJString(name))
  add(path_568443, "vnetName", newJString(vnetName))
  add(path_568443, "gatewayName", newJString(gatewayName))
  add(path_568443, "subscriptionId", newJString(subscriptionId))
  result = call_568442.call(path_568443, query_568444, nil, nil, nil)

var appServicePlansGetVnetGateway* = Call_AppServicePlansGetVnetGateway_568432(
    name: "appServicePlansGetVnetGateway", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}/gateways/{gatewayName}",
    validator: validate_AppServicePlansGetVnetGateway_568433, base: "",
    url: url_AppServicePlansGetVnetGateway_568434, schemes: {Scheme.Https})
type
  Call_AppServicePlansListRoutesForVnet_568460 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansListRoutesForVnet_568462(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "vnetName" in path, "`vnetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/virtualNetworkConnections/"),
               (kind: VariableSegment, value: "vnetName"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansListRoutesForVnet_568461(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all routes that are associated with a Virtual Network in an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   vnetName: JString (required)
  ##           : Name of the Virtual Network.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568463 = path.getOrDefault("resourceGroupName")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "resourceGroupName", valid_568463
  var valid_568464 = path.getOrDefault("name")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "name", valid_568464
  var valid_568465 = path.getOrDefault("vnetName")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "vnetName", valid_568465
  var valid_568466 = path.getOrDefault("subscriptionId")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "subscriptionId", valid_568466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568467 = query.getOrDefault("api-version")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "api-version", valid_568467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568468: Call_AppServicePlansListRoutesForVnet_568460;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all routes that are associated with a Virtual Network in an App Service plan.
  ## 
  let valid = call_568468.validator(path, query, header, formData, body)
  let scheme = call_568468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568468.url(scheme.get, call_568468.host, call_568468.base,
                         call_568468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568468, url, valid)

proc call*(call_568469: Call_AppServicePlansListRoutesForVnet_568460;
          resourceGroupName: string; apiVersion: string; name: string;
          vnetName: string; subscriptionId: string): Recallable =
  ## appServicePlansListRoutesForVnet
  ## Get all routes that are associated with a Virtual Network in an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   vnetName: string (required)
  ##           : Name of the Virtual Network.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568470 = newJObject()
  var query_568471 = newJObject()
  add(path_568470, "resourceGroupName", newJString(resourceGroupName))
  add(query_568471, "api-version", newJString(apiVersion))
  add(path_568470, "name", newJString(name))
  add(path_568470, "vnetName", newJString(vnetName))
  add(path_568470, "subscriptionId", newJString(subscriptionId))
  result = call_568469.call(path_568470, query_568471, nil, nil, nil)

var appServicePlansListRoutesForVnet* = Call_AppServicePlansListRoutesForVnet_568460(
    name: "appServicePlansListRoutesForVnet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}/routes",
    validator: validate_AppServicePlansListRoutesForVnet_568461, base: "",
    url: url_AppServicePlansListRoutesForVnet_568462, schemes: {Scheme.Https})
type
  Call_AppServicePlansCreateOrUpdateVnetRoute_568485 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansCreateOrUpdateVnetRoute_568487(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "vnetName" in path, "`vnetName` is a required path parameter"
  assert "routeName" in path, "`routeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/virtualNetworkConnections/"),
               (kind: VariableSegment, value: "vnetName"),
               (kind: ConstantSegment, value: "/routes/"),
               (kind: VariableSegment, value: "routeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansCreateOrUpdateVnetRoute_568486(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Virtual Network route in an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   vnetName: JString (required)
  ##           : Name of the Virtual Network.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   routeName: JString (required)
  ##            : Name of the Virtual Network route.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568488 = path.getOrDefault("resourceGroupName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "resourceGroupName", valid_568488
  var valid_568489 = path.getOrDefault("name")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "name", valid_568489
  var valid_568490 = path.getOrDefault("vnetName")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "vnetName", valid_568490
  var valid_568491 = path.getOrDefault("subscriptionId")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "subscriptionId", valid_568491
  var valid_568492 = path.getOrDefault("routeName")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "routeName", valid_568492
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568493 = query.getOrDefault("api-version")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "api-version", valid_568493
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   route: JObject (required)
  ##        : Definition of the Virtual Network route.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568495: Call_AppServicePlansCreateOrUpdateVnetRoute_568485;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a Virtual Network route in an App Service plan.
  ## 
  let valid = call_568495.validator(path, query, header, formData, body)
  let scheme = call_568495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568495.url(scheme.get, call_568495.host, call_568495.base,
                         call_568495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568495, url, valid)

proc call*(call_568496: Call_AppServicePlansCreateOrUpdateVnetRoute_568485;
          resourceGroupName: string; apiVersion: string; name: string;
          vnetName: string; subscriptionId: string; routeName: string; route: JsonNode): Recallable =
  ## appServicePlansCreateOrUpdateVnetRoute
  ## Create or update a Virtual Network route in an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   vnetName: string (required)
  ##           : Name of the Virtual Network.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   routeName: string (required)
  ##            : Name of the Virtual Network route.
  ##   route: JObject (required)
  ##        : Definition of the Virtual Network route.
  var path_568497 = newJObject()
  var query_568498 = newJObject()
  var body_568499 = newJObject()
  add(path_568497, "resourceGroupName", newJString(resourceGroupName))
  add(query_568498, "api-version", newJString(apiVersion))
  add(path_568497, "name", newJString(name))
  add(path_568497, "vnetName", newJString(vnetName))
  add(path_568497, "subscriptionId", newJString(subscriptionId))
  add(path_568497, "routeName", newJString(routeName))
  if route != nil:
    body_568499 = route
  result = call_568496.call(path_568497, query_568498, nil, nil, body_568499)

var appServicePlansCreateOrUpdateVnetRoute* = Call_AppServicePlansCreateOrUpdateVnetRoute_568485(
    name: "appServicePlansCreateOrUpdateVnetRoute", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}/routes/{routeName}",
    validator: validate_AppServicePlansCreateOrUpdateVnetRoute_568486, base: "",
    url: url_AppServicePlansCreateOrUpdateVnetRoute_568487,
    schemes: {Scheme.Https})
type
  Call_AppServicePlansGetRouteForVnet_568472 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansGetRouteForVnet_568474(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "vnetName" in path, "`vnetName` is a required path parameter"
  assert "routeName" in path, "`routeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/virtualNetworkConnections/"),
               (kind: VariableSegment, value: "vnetName"),
               (kind: ConstantSegment, value: "/routes/"),
               (kind: VariableSegment, value: "routeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansGetRouteForVnet_568473(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Virtual Network route in an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   vnetName: JString (required)
  ##           : Name of the Virtual Network.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   routeName: JString (required)
  ##            : Name of the Virtual Network route.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568475 = path.getOrDefault("resourceGroupName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "resourceGroupName", valid_568475
  var valid_568476 = path.getOrDefault("name")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "name", valid_568476
  var valid_568477 = path.getOrDefault("vnetName")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "vnetName", valid_568477
  var valid_568478 = path.getOrDefault("subscriptionId")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "subscriptionId", valid_568478
  var valid_568479 = path.getOrDefault("routeName")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "routeName", valid_568479
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568480 = query.getOrDefault("api-version")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "api-version", valid_568480
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568481: Call_AppServicePlansGetRouteForVnet_568472; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Virtual Network route in an App Service plan.
  ## 
  let valid = call_568481.validator(path, query, header, formData, body)
  let scheme = call_568481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568481.url(scheme.get, call_568481.host, call_568481.base,
                         call_568481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568481, url, valid)

proc call*(call_568482: Call_AppServicePlansGetRouteForVnet_568472;
          resourceGroupName: string; apiVersion: string; name: string;
          vnetName: string; subscriptionId: string; routeName: string): Recallable =
  ## appServicePlansGetRouteForVnet
  ## Get a Virtual Network route in an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   vnetName: string (required)
  ##           : Name of the Virtual Network.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   routeName: string (required)
  ##            : Name of the Virtual Network route.
  var path_568483 = newJObject()
  var query_568484 = newJObject()
  add(path_568483, "resourceGroupName", newJString(resourceGroupName))
  add(query_568484, "api-version", newJString(apiVersion))
  add(path_568483, "name", newJString(name))
  add(path_568483, "vnetName", newJString(vnetName))
  add(path_568483, "subscriptionId", newJString(subscriptionId))
  add(path_568483, "routeName", newJString(routeName))
  result = call_568482.call(path_568483, query_568484, nil, nil, nil)

var appServicePlansGetRouteForVnet* = Call_AppServicePlansGetRouteForVnet_568472(
    name: "appServicePlansGetRouteForVnet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}/routes/{routeName}",
    validator: validate_AppServicePlansGetRouteForVnet_568473, base: "",
    url: url_AppServicePlansGetRouteForVnet_568474, schemes: {Scheme.Https})
type
  Call_AppServicePlansUpdateVnetRoute_568513 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansUpdateVnetRoute_568515(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "vnetName" in path, "`vnetName` is a required path parameter"
  assert "routeName" in path, "`routeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/virtualNetworkConnections/"),
               (kind: VariableSegment, value: "vnetName"),
               (kind: ConstantSegment, value: "/routes/"),
               (kind: VariableSegment, value: "routeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansUpdateVnetRoute_568514(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Virtual Network route in an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   vnetName: JString (required)
  ##           : Name of the Virtual Network.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   routeName: JString (required)
  ##            : Name of the Virtual Network route.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568516 = path.getOrDefault("resourceGroupName")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "resourceGroupName", valid_568516
  var valid_568517 = path.getOrDefault("name")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "name", valid_568517
  var valid_568518 = path.getOrDefault("vnetName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "vnetName", valid_568518
  var valid_568519 = path.getOrDefault("subscriptionId")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "subscriptionId", valid_568519
  var valid_568520 = path.getOrDefault("routeName")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "routeName", valid_568520
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568521 = query.getOrDefault("api-version")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "api-version", valid_568521
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   route: JObject (required)
  ##        : Definition of the Virtual Network route.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568523: Call_AppServicePlansUpdateVnetRoute_568513; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Virtual Network route in an App Service plan.
  ## 
  let valid = call_568523.validator(path, query, header, formData, body)
  let scheme = call_568523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568523.url(scheme.get, call_568523.host, call_568523.base,
                         call_568523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568523, url, valid)

proc call*(call_568524: Call_AppServicePlansUpdateVnetRoute_568513;
          resourceGroupName: string; apiVersion: string; name: string;
          vnetName: string; subscriptionId: string; routeName: string; route: JsonNode): Recallable =
  ## appServicePlansUpdateVnetRoute
  ## Create or update a Virtual Network route in an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   vnetName: string (required)
  ##           : Name of the Virtual Network.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   routeName: string (required)
  ##            : Name of the Virtual Network route.
  ##   route: JObject (required)
  ##        : Definition of the Virtual Network route.
  var path_568525 = newJObject()
  var query_568526 = newJObject()
  var body_568527 = newJObject()
  add(path_568525, "resourceGroupName", newJString(resourceGroupName))
  add(query_568526, "api-version", newJString(apiVersion))
  add(path_568525, "name", newJString(name))
  add(path_568525, "vnetName", newJString(vnetName))
  add(path_568525, "subscriptionId", newJString(subscriptionId))
  add(path_568525, "routeName", newJString(routeName))
  if route != nil:
    body_568527 = route
  result = call_568524.call(path_568525, query_568526, nil, nil, body_568527)

var appServicePlansUpdateVnetRoute* = Call_AppServicePlansUpdateVnetRoute_568513(
    name: "appServicePlansUpdateVnetRoute", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}/routes/{routeName}",
    validator: validate_AppServicePlansUpdateVnetRoute_568514, base: "",
    url: url_AppServicePlansUpdateVnetRoute_568515, schemes: {Scheme.Https})
type
  Call_AppServicePlansDeleteVnetRoute_568500 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansDeleteVnetRoute_568502(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "vnetName" in path, "`vnetName` is a required path parameter"
  assert "routeName" in path, "`routeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/virtualNetworkConnections/"),
               (kind: VariableSegment, value: "vnetName"),
               (kind: ConstantSegment, value: "/routes/"),
               (kind: VariableSegment, value: "routeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansDeleteVnetRoute_568501(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Virtual Network route in an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   vnetName: JString (required)
  ##           : Name of the Virtual Network.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   routeName: JString (required)
  ##            : Name of the Virtual Network route.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568503 = path.getOrDefault("resourceGroupName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "resourceGroupName", valid_568503
  var valid_568504 = path.getOrDefault("name")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "name", valid_568504
  var valid_568505 = path.getOrDefault("vnetName")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "vnetName", valid_568505
  var valid_568506 = path.getOrDefault("subscriptionId")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "subscriptionId", valid_568506
  var valid_568507 = path.getOrDefault("routeName")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "routeName", valid_568507
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568508 = query.getOrDefault("api-version")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "api-version", valid_568508
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568509: Call_AppServicePlansDeleteVnetRoute_568500; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Virtual Network route in an App Service plan.
  ## 
  let valid = call_568509.validator(path, query, header, formData, body)
  let scheme = call_568509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568509.url(scheme.get, call_568509.host, call_568509.base,
                         call_568509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568509, url, valid)

proc call*(call_568510: Call_AppServicePlansDeleteVnetRoute_568500;
          resourceGroupName: string; apiVersion: string; name: string;
          vnetName: string; subscriptionId: string; routeName: string): Recallable =
  ## appServicePlansDeleteVnetRoute
  ## Delete a Virtual Network route in an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   vnetName: string (required)
  ##           : Name of the Virtual Network.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   routeName: string (required)
  ##            : Name of the Virtual Network route.
  var path_568511 = newJObject()
  var query_568512 = newJObject()
  add(path_568511, "resourceGroupName", newJString(resourceGroupName))
  add(query_568512, "api-version", newJString(apiVersion))
  add(path_568511, "name", newJString(name))
  add(path_568511, "vnetName", newJString(vnetName))
  add(path_568511, "subscriptionId", newJString(subscriptionId))
  add(path_568511, "routeName", newJString(routeName))
  result = call_568510.call(path_568511, query_568512, nil, nil, nil)

var appServicePlansDeleteVnetRoute* = Call_AppServicePlansDeleteVnetRoute_568500(
    name: "appServicePlansDeleteVnetRoute", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}/routes/{routeName}",
    validator: validate_AppServicePlansDeleteVnetRoute_568501, base: "",
    url: url_AppServicePlansDeleteVnetRoute_568502, schemes: {Scheme.Https})
type
  Call_AppServicePlansRebootWorker_568528 = ref object of OpenApiRestCall_567657
proc url_AppServicePlansRebootWorker_568530(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerName" in path, "`workerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/serverfarms/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workers/"),
               (kind: VariableSegment, value: "workerName"),
               (kind: ConstantSegment, value: "/reboot")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServicePlansRebootWorker_568529(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reboot a worker machine in an App Service plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   workerName: JString (required)
  ##             : Name of worker machine, which typically starts with RD.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568531 = path.getOrDefault("resourceGroupName")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "resourceGroupName", valid_568531
  var valid_568532 = path.getOrDefault("name")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "name", valid_568532
  var valid_568533 = path.getOrDefault("subscriptionId")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "subscriptionId", valid_568533
  var valid_568534 = path.getOrDefault("workerName")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "workerName", valid_568534
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568535 = query.getOrDefault("api-version")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "api-version", valid_568535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568536: Call_AppServicePlansRebootWorker_568528; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reboot a worker machine in an App Service plan.
  ## 
  let valid = call_568536.validator(path, query, header, formData, body)
  let scheme = call_568536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568536.url(scheme.get, call_568536.host, call_568536.base,
                         call_568536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568536, url, valid)

proc call*(call_568537: Call_AppServicePlansRebootWorker_568528;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; workerName: string): Recallable =
  ## appServicePlansRebootWorker
  ## Reboot a worker machine in an App Service plan.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service plan.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   workerName: string (required)
  ##             : Name of worker machine, which typically starts with RD.
  var path_568538 = newJObject()
  var query_568539 = newJObject()
  add(path_568538, "resourceGroupName", newJString(resourceGroupName))
  add(query_568539, "api-version", newJString(apiVersion))
  add(path_568538, "name", newJString(name))
  add(path_568538, "subscriptionId", newJString(subscriptionId))
  add(path_568538, "workerName", newJString(workerName))
  result = call_568537.call(path_568538, query_568539, nil, nil, nil)

var appServicePlansRebootWorker* = Call_AppServicePlansRebootWorker_568528(
    name: "appServicePlansRebootWorker", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/workers/{workerName}/reboot",
    validator: validate_AppServicePlansRebootWorker_568529, base: "",
    url: url_AppServicePlansRebootWorker_568530, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
