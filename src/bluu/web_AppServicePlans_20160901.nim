
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_AppServicePlansList_593646 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansList_593648(protocol: Scheme; host: string; base: string;
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

proc validate_AppServicePlansList_593647(path: JsonNode; query: JsonNode;
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
  var valid_593821 = path.getOrDefault("subscriptionId")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "subscriptionId", valid_593821
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
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  var valid_593823 = query.getOrDefault("detailed")
  valid_593823 = validateParameter(valid_593823, JBool, required = false, default = nil)
  if valid_593823 != nil:
    section.add "detailed", valid_593823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593846: Call_AppServicePlansList_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all App Service plans for a subscription.
  ## 
  let valid = call_593846.validator(path, query, header, formData, body)
  let scheme = call_593846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593846.url(scheme.get, call_593846.host, call_593846.base,
                         call_593846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593846, url, valid)

proc call*(call_593917: Call_AppServicePlansList_593646; apiVersion: string;
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
  var path_593918 = newJObject()
  var query_593920 = newJObject()
  add(query_593920, "api-version", newJString(apiVersion))
  add(query_593920, "detailed", newJBool(detailed))
  add(path_593918, "subscriptionId", newJString(subscriptionId))
  result = call_593917.call(path_593918, query_593920, nil, nil, nil)

var appServicePlansList* = Call_AppServicePlansList_593646(
    name: "appServicePlansList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/serverfarms",
    validator: validate_AppServicePlansList_593647, base: "",
    url: url_AppServicePlansList_593648, schemes: {Scheme.Https})
type
  Call_AppServicePlansListByResourceGroup_593959 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansListByResourceGroup_593961(protocol: Scheme; host: string;
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

proc validate_AppServicePlansListByResourceGroup_593960(path: JsonNode;
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
  var valid_593962 = path.getOrDefault("resourceGroupName")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "resourceGroupName", valid_593962
  var valid_593963 = path.getOrDefault("subscriptionId")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "subscriptionId", valid_593963
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593964 = query.getOrDefault("api-version")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "api-version", valid_593964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593965: Call_AppServicePlansListByResourceGroup_593959;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all App Service plans in a resource group.
  ## 
  let valid = call_593965.validator(path, query, header, formData, body)
  let scheme = call_593965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593965.url(scheme.get, call_593965.host, call_593965.base,
                         call_593965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593965, url, valid)

proc call*(call_593966: Call_AppServicePlansListByResourceGroup_593959;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## appServicePlansListByResourceGroup
  ## Get all App Service plans in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_593967 = newJObject()
  var query_593968 = newJObject()
  add(path_593967, "resourceGroupName", newJString(resourceGroupName))
  add(query_593968, "api-version", newJString(apiVersion))
  add(path_593967, "subscriptionId", newJString(subscriptionId))
  result = call_593966.call(path_593967, query_593968, nil, nil, nil)

var appServicePlansListByResourceGroup* = Call_AppServicePlansListByResourceGroup_593959(
    name: "appServicePlansListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms",
    validator: validate_AppServicePlansListByResourceGroup_593960, base: "",
    url: url_AppServicePlansListByResourceGroup_593961, schemes: {Scheme.Https})
type
  Call_AppServicePlansCreateOrUpdate_593980 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansCreateOrUpdate_593982(protocol: Scheme; host: string;
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

proc validate_AppServicePlansCreateOrUpdate_593981(path: JsonNode; query: JsonNode;
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
  var valid_593983 = path.getOrDefault("resourceGroupName")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "resourceGroupName", valid_593983
  var valid_593984 = path.getOrDefault("name")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "name", valid_593984
  var valid_593985 = path.getOrDefault("subscriptionId")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "subscriptionId", valid_593985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593986 = query.getOrDefault("api-version")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "api-version", valid_593986
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

proc call*(call_593988: Call_AppServicePlansCreateOrUpdate_593980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an App Service Plan.
  ## 
  let valid = call_593988.validator(path, query, header, formData, body)
  let scheme = call_593988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593988.url(scheme.get, call_593988.host, call_593988.base,
                         call_593988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593988, url, valid)

proc call*(call_593989: Call_AppServicePlansCreateOrUpdate_593980;
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
  var path_593990 = newJObject()
  var query_593991 = newJObject()
  var body_593992 = newJObject()
  add(path_593990, "resourceGroupName", newJString(resourceGroupName))
  add(query_593991, "api-version", newJString(apiVersion))
  add(path_593990, "name", newJString(name))
  add(path_593990, "subscriptionId", newJString(subscriptionId))
  if appServicePlan != nil:
    body_593992 = appServicePlan
  result = call_593989.call(path_593990, query_593991, nil, nil, body_593992)

var appServicePlansCreateOrUpdate* = Call_AppServicePlansCreateOrUpdate_593980(
    name: "appServicePlansCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}",
    validator: validate_AppServicePlansCreateOrUpdate_593981, base: "",
    url: url_AppServicePlansCreateOrUpdate_593982, schemes: {Scheme.Https})
type
  Call_AppServicePlansGet_593969 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansGet_593971(protocol: Scheme; host: string; base: string;
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

proc validate_AppServicePlansGet_593970(path: JsonNode; query: JsonNode;
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
  var valid_593972 = path.getOrDefault("resourceGroupName")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "resourceGroupName", valid_593972
  var valid_593973 = path.getOrDefault("name")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "name", valid_593973
  var valid_593974 = path.getOrDefault("subscriptionId")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "subscriptionId", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593976: Call_AppServicePlansGet_593969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an App Service plan.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_AppServicePlansGet_593969; resourceGroupName: string;
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
  var path_593978 = newJObject()
  var query_593979 = newJObject()
  add(path_593978, "resourceGroupName", newJString(resourceGroupName))
  add(query_593979, "api-version", newJString(apiVersion))
  add(path_593978, "name", newJString(name))
  add(path_593978, "subscriptionId", newJString(subscriptionId))
  result = call_593977.call(path_593978, query_593979, nil, nil, nil)

var appServicePlansGet* = Call_AppServicePlansGet_593969(
    name: "appServicePlansGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}",
    validator: validate_AppServicePlansGet_593970, base: "",
    url: url_AppServicePlansGet_593971, schemes: {Scheme.Https})
type
  Call_AppServicePlansUpdate_594004 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansUpdate_594006(protocol: Scheme; host: string; base: string;
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

proc validate_AppServicePlansUpdate_594005(path: JsonNode; query: JsonNode;
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
  var valid_594007 = path.getOrDefault("resourceGroupName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "resourceGroupName", valid_594007
  var valid_594008 = path.getOrDefault("name")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "name", valid_594008
  var valid_594009 = path.getOrDefault("subscriptionId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "subscriptionId", valid_594009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594010 = query.getOrDefault("api-version")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "api-version", valid_594010
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

proc call*(call_594012: Call_AppServicePlansUpdate_594004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an App Service Plan.
  ## 
  let valid = call_594012.validator(path, query, header, formData, body)
  let scheme = call_594012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594012.url(scheme.get, call_594012.host, call_594012.base,
                         call_594012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594012, url, valid)

proc call*(call_594013: Call_AppServicePlansUpdate_594004;
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
  var path_594014 = newJObject()
  var query_594015 = newJObject()
  var body_594016 = newJObject()
  add(path_594014, "resourceGroupName", newJString(resourceGroupName))
  add(query_594015, "api-version", newJString(apiVersion))
  add(path_594014, "name", newJString(name))
  add(path_594014, "subscriptionId", newJString(subscriptionId))
  if appServicePlan != nil:
    body_594016 = appServicePlan
  result = call_594013.call(path_594014, query_594015, nil, nil, body_594016)

var appServicePlansUpdate* = Call_AppServicePlansUpdate_594004(
    name: "appServicePlansUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}",
    validator: validate_AppServicePlansUpdate_594005, base: "",
    url: url_AppServicePlansUpdate_594006, schemes: {Scheme.Https})
type
  Call_AppServicePlansDelete_593993 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansDelete_593995(protocol: Scheme; host: string; base: string;
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

proc validate_AppServicePlansDelete_593994(path: JsonNode; query: JsonNode;
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
  var valid_593996 = path.getOrDefault("resourceGroupName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "resourceGroupName", valid_593996
  var valid_593997 = path.getOrDefault("name")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "name", valid_593997
  var valid_593998 = path.getOrDefault("subscriptionId")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "subscriptionId", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593999 = query.getOrDefault("api-version")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "api-version", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_AppServicePlansDelete_593993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an App Service plan.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_AppServicePlansDelete_593993;
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
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(path_594002, "resourceGroupName", newJString(resourceGroupName))
  add(query_594003, "api-version", newJString(apiVersion))
  add(path_594002, "name", newJString(name))
  add(path_594002, "subscriptionId", newJString(subscriptionId))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var appServicePlansDelete* = Call_AppServicePlansDelete_593993(
    name: "appServicePlansDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}",
    validator: validate_AppServicePlansDelete_593994, base: "",
    url: url_AppServicePlansDelete_593995, schemes: {Scheme.Https})
type
  Call_AppServicePlansListCapabilities_594017 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansListCapabilities_594019(protocol: Scheme; host: string;
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

proc validate_AppServicePlansListCapabilities_594018(path: JsonNode;
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
  var valid_594020 = path.getOrDefault("resourceGroupName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "resourceGroupName", valid_594020
  var valid_594021 = path.getOrDefault("name")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "name", valid_594021
  var valid_594022 = path.getOrDefault("subscriptionId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "subscriptionId", valid_594022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594023 = query.getOrDefault("api-version")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "api-version", valid_594023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_AppServicePlansListCapabilities_594017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all capabilities of an App Service plan.
  ## 
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_AppServicePlansListCapabilities_594017;
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
  var path_594026 = newJObject()
  var query_594027 = newJObject()
  add(path_594026, "resourceGroupName", newJString(resourceGroupName))
  add(query_594027, "api-version", newJString(apiVersion))
  add(path_594026, "name", newJString(name))
  add(path_594026, "subscriptionId", newJString(subscriptionId))
  result = call_594025.call(path_594026, query_594027, nil, nil, nil)

var appServicePlansListCapabilities* = Call_AppServicePlansListCapabilities_594017(
    name: "appServicePlansListCapabilities", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/capabilities",
    validator: validate_AppServicePlansListCapabilities_594018, base: "",
    url: url_AppServicePlansListCapabilities_594019, schemes: {Scheme.Https})
type
  Call_AppServicePlansGetHybridConnection_594028 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansGetHybridConnection_594030(protocol: Scheme; host: string;
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

proc validate_AppServicePlansGetHybridConnection_594029(path: JsonNode;
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
  var valid_594031 = path.getOrDefault("namespaceName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "namespaceName", valid_594031
  var valid_594032 = path.getOrDefault("resourceGroupName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "resourceGroupName", valid_594032
  var valid_594033 = path.getOrDefault("name")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "name", valid_594033
  var valid_594034 = path.getOrDefault("subscriptionId")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "subscriptionId", valid_594034
  var valid_594035 = path.getOrDefault("relayName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "relayName", valid_594035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594036 = query.getOrDefault("api-version")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "api-version", valid_594036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_AppServicePlansGetHybridConnection_594028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a Hybrid Connection in use in an App Service plan.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_AppServicePlansGetHybridConnection_594028;
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
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  add(path_594039, "namespaceName", newJString(namespaceName))
  add(path_594039, "resourceGroupName", newJString(resourceGroupName))
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "name", newJString(name))
  add(path_594039, "subscriptionId", newJString(subscriptionId))
  add(path_594039, "relayName", newJString(relayName))
  result = call_594038.call(path_594039, query_594040, nil, nil, nil)

var appServicePlansGetHybridConnection* = Call_AppServicePlansGetHybridConnection_594028(
    name: "appServicePlansGetHybridConnection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/hybridConnectionNamespaces/{namespaceName}/relays/{relayName}",
    validator: validate_AppServicePlansGetHybridConnection_594029, base: "",
    url: url_AppServicePlansGetHybridConnection_594030, schemes: {Scheme.Https})
type
  Call_AppServicePlansDeleteHybridConnection_594041 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansDeleteHybridConnection_594043(protocol: Scheme;
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

proc validate_AppServicePlansDeleteHybridConnection_594042(path: JsonNode;
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
  var valid_594044 = path.getOrDefault("namespaceName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "namespaceName", valid_594044
  var valid_594045 = path.getOrDefault("resourceGroupName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "resourceGroupName", valid_594045
  var valid_594046 = path.getOrDefault("name")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "name", valid_594046
  var valid_594047 = path.getOrDefault("subscriptionId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "subscriptionId", valid_594047
  var valid_594048 = path.getOrDefault("relayName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "relayName", valid_594048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594049 = query.getOrDefault("api-version")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "api-version", valid_594049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594050: Call_AppServicePlansDeleteHybridConnection_594041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a Hybrid Connection in use in an App Service plan.
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_AppServicePlansDeleteHybridConnection_594041;
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
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  add(path_594052, "namespaceName", newJString(namespaceName))
  add(path_594052, "resourceGroupName", newJString(resourceGroupName))
  add(query_594053, "api-version", newJString(apiVersion))
  add(path_594052, "name", newJString(name))
  add(path_594052, "subscriptionId", newJString(subscriptionId))
  add(path_594052, "relayName", newJString(relayName))
  result = call_594051.call(path_594052, query_594053, nil, nil, nil)

var appServicePlansDeleteHybridConnection* = Call_AppServicePlansDeleteHybridConnection_594041(
    name: "appServicePlansDeleteHybridConnection", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/hybridConnectionNamespaces/{namespaceName}/relays/{relayName}",
    validator: validate_AppServicePlansDeleteHybridConnection_594042, base: "",
    url: url_AppServicePlansDeleteHybridConnection_594043, schemes: {Scheme.Https})
type
  Call_AppServicePlansListHybridConnectionKeys_594054 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansListHybridConnectionKeys_594056(protocol: Scheme;
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

proc validate_AppServicePlansListHybridConnectionKeys_594055(path: JsonNode;
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
  var valid_594057 = path.getOrDefault("namespaceName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "namespaceName", valid_594057
  var valid_594058 = path.getOrDefault("resourceGroupName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "resourceGroupName", valid_594058
  var valid_594059 = path.getOrDefault("name")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "name", valid_594059
  var valid_594060 = path.getOrDefault("subscriptionId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "subscriptionId", valid_594060
  var valid_594061 = path.getOrDefault("relayName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "relayName", valid_594061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594062 = query.getOrDefault("api-version")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "api-version", valid_594062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594063: Call_AppServicePlansListHybridConnectionKeys_594054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the send key name and value of a Hybrid Connection.
  ## 
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_AppServicePlansListHybridConnectionKeys_594054;
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
  var path_594065 = newJObject()
  var query_594066 = newJObject()
  add(path_594065, "namespaceName", newJString(namespaceName))
  add(path_594065, "resourceGroupName", newJString(resourceGroupName))
  add(query_594066, "api-version", newJString(apiVersion))
  add(path_594065, "name", newJString(name))
  add(path_594065, "subscriptionId", newJString(subscriptionId))
  add(path_594065, "relayName", newJString(relayName))
  result = call_594064.call(path_594065, query_594066, nil, nil, nil)

var appServicePlansListHybridConnectionKeys* = Call_AppServicePlansListHybridConnectionKeys_594054(
    name: "appServicePlansListHybridConnectionKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/hybridConnectionNamespaces/{namespaceName}/relays/{relayName}/listKeys",
    validator: validate_AppServicePlansListHybridConnectionKeys_594055, base: "",
    url: url_AppServicePlansListHybridConnectionKeys_594056,
    schemes: {Scheme.Https})
type
  Call_AppServicePlansListWebAppsByHybridConnection_594067 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansListWebAppsByHybridConnection_594069(protocol: Scheme;
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

proc validate_AppServicePlansListWebAppsByHybridConnection_594068(path: JsonNode;
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
  var valid_594070 = path.getOrDefault("namespaceName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "namespaceName", valid_594070
  var valid_594071 = path.getOrDefault("resourceGroupName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "resourceGroupName", valid_594071
  var valid_594072 = path.getOrDefault("name")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "name", valid_594072
  var valid_594073 = path.getOrDefault("subscriptionId")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "subscriptionId", valid_594073
  var valid_594074 = path.getOrDefault("relayName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "relayName", valid_594074
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594075 = query.getOrDefault("api-version")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "api-version", valid_594075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594076: Call_AppServicePlansListWebAppsByHybridConnection_594067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all apps that use a Hybrid Connection in an App Service Plan.
  ## 
  let valid = call_594076.validator(path, query, header, formData, body)
  let scheme = call_594076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594076.url(scheme.get, call_594076.host, call_594076.base,
                         call_594076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594076, url, valid)

proc call*(call_594077: Call_AppServicePlansListWebAppsByHybridConnection_594067;
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
  var path_594078 = newJObject()
  var query_594079 = newJObject()
  add(path_594078, "namespaceName", newJString(namespaceName))
  add(path_594078, "resourceGroupName", newJString(resourceGroupName))
  add(query_594079, "api-version", newJString(apiVersion))
  add(path_594078, "name", newJString(name))
  add(path_594078, "subscriptionId", newJString(subscriptionId))
  add(path_594078, "relayName", newJString(relayName))
  result = call_594077.call(path_594078, query_594079, nil, nil, nil)

var appServicePlansListWebAppsByHybridConnection* = Call_AppServicePlansListWebAppsByHybridConnection_594067(
    name: "appServicePlansListWebAppsByHybridConnection",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/hybridConnectionNamespaces/{namespaceName}/relays/{relayName}/sites",
    validator: validate_AppServicePlansListWebAppsByHybridConnection_594068,
    base: "", url: url_AppServicePlansListWebAppsByHybridConnection_594069,
    schemes: {Scheme.Https})
type
  Call_AppServicePlansGetHybridConnectionPlanLimit_594080 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansGetHybridConnectionPlanLimit_594082(protocol: Scheme;
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

proc validate_AppServicePlansGetHybridConnectionPlanLimit_594081(path: JsonNode;
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
  var valid_594083 = path.getOrDefault("resourceGroupName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "resourceGroupName", valid_594083
  var valid_594084 = path.getOrDefault("name")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "name", valid_594084
  var valid_594085 = path.getOrDefault("subscriptionId")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "subscriptionId", valid_594085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594086 = query.getOrDefault("api-version")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "api-version", valid_594086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594087: Call_AppServicePlansGetHybridConnectionPlanLimit_594080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the maximum number of Hybrid Connections allowed in an App Service plan.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_AppServicePlansGetHybridConnectionPlanLimit_594080;
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
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  add(path_594089, "resourceGroupName", newJString(resourceGroupName))
  add(query_594090, "api-version", newJString(apiVersion))
  add(path_594089, "name", newJString(name))
  add(path_594089, "subscriptionId", newJString(subscriptionId))
  result = call_594088.call(path_594089, query_594090, nil, nil, nil)

var appServicePlansGetHybridConnectionPlanLimit* = Call_AppServicePlansGetHybridConnectionPlanLimit_594080(
    name: "appServicePlansGetHybridConnectionPlanLimit", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/hybridConnectionPlanLimits/limit",
    validator: validate_AppServicePlansGetHybridConnectionPlanLimit_594081,
    base: "", url: url_AppServicePlansGetHybridConnectionPlanLimit_594082,
    schemes: {Scheme.Https})
type
  Call_AppServicePlansListHybridConnections_594091 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansListHybridConnections_594093(protocol: Scheme;
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

proc validate_AppServicePlansListHybridConnections_594092(path: JsonNode;
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
  var valid_594094 = path.getOrDefault("resourceGroupName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "resourceGroupName", valid_594094
  var valid_594095 = path.getOrDefault("name")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "name", valid_594095
  var valid_594096 = path.getOrDefault("subscriptionId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "subscriptionId", valid_594096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594097 = query.getOrDefault("api-version")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "api-version", valid_594097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594098: Call_AppServicePlansListHybridConnections_594091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve all Hybrid Connections in use in an App Service plan.
  ## 
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_AppServicePlansListHybridConnections_594091;
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
  var path_594100 = newJObject()
  var query_594101 = newJObject()
  add(path_594100, "resourceGroupName", newJString(resourceGroupName))
  add(query_594101, "api-version", newJString(apiVersion))
  add(path_594100, "name", newJString(name))
  add(path_594100, "subscriptionId", newJString(subscriptionId))
  result = call_594099.call(path_594100, query_594101, nil, nil, nil)

var appServicePlansListHybridConnections* = Call_AppServicePlansListHybridConnections_594091(
    name: "appServicePlansListHybridConnections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/hybridConnectionRelays",
    validator: validate_AppServicePlansListHybridConnections_594092, base: "",
    url: url_AppServicePlansListHybridConnections_594093, schemes: {Scheme.Https})
type
  Call_AppServicePlansListMetricDefintions_594102 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansListMetricDefintions_594104(protocol: Scheme; host: string;
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

proc validate_AppServicePlansListMetricDefintions_594103(path: JsonNode;
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
  var valid_594105 = path.getOrDefault("resourceGroupName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "resourceGroupName", valid_594105
  var valid_594106 = path.getOrDefault("name")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "name", valid_594106
  var valid_594107 = path.getOrDefault("subscriptionId")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "subscriptionId", valid_594107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594108 = query.getOrDefault("api-version")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "api-version", valid_594108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594109: Call_AppServicePlansListMetricDefintions_594102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics that can be queried for an App Service plan, and their definitions.
  ## 
  let valid = call_594109.validator(path, query, header, formData, body)
  let scheme = call_594109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594109.url(scheme.get, call_594109.host, call_594109.base,
                         call_594109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594109, url, valid)

proc call*(call_594110: Call_AppServicePlansListMetricDefintions_594102;
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
  var path_594111 = newJObject()
  var query_594112 = newJObject()
  add(path_594111, "resourceGroupName", newJString(resourceGroupName))
  add(query_594112, "api-version", newJString(apiVersion))
  add(path_594111, "name", newJString(name))
  add(path_594111, "subscriptionId", newJString(subscriptionId))
  result = call_594110.call(path_594111, query_594112, nil, nil, nil)

var appServicePlansListMetricDefintions* = Call_AppServicePlansListMetricDefintions_594102(
    name: "appServicePlansListMetricDefintions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/metricdefinitions",
    validator: validate_AppServicePlansListMetricDefintions_594103, base: "",
    url: url_AppServicePlansListMetricDefintions_594104, schemes: {Scheme.Https})
type
  Call_AppServicePlansListMetrics_594113 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansListMetrics_594115(protocol: Scheme; host: string;
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

proc validate_AppServicePlansListMetrics_594114(path: JsonNode; query: JsonNode;
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
  var valid_594117 = path.getOrDefault("resourceGroupName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "resourceGroupName", valid_594117
  var valid_594118 = path.getOrDefault("name")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "name", valid_594118
  var valid_594119 = path.getOrDefault("subscriptionId")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "subscriptionId", valid_594119
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
  var valid_594120 = query.getOrDefault("api-version")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "api-version", valid_594120
  var valid_594121 = query.getOrDefault("details")
  valid_594121 = validateParameter(valid_594121, JBool, required = false, default = nil)
  if valid_594121 != nil:
    section.add "details", valid_594121
  var valid_594122 = query.getOrDefault("$filter")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "$filter", valid_594122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594123: Call_AppServicePlansListMetrics_594113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get metrics for an App Service plan.
  ## 
  let valid = call_594123.validator(path, query, header, formData, body)
  let scheme = call_594123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594123.url(scheme.get, call_594123.host, call_594123.base,
                         call_594123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594123, url, valid)

proc call*(call_594124: Call_AppServicePlansListMetrics_594113;
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
  var path_594125 = newJObject()
  var query_594126 = newJObject()
  add(path_594125, "resourceGroupName", newJString(resourceGroupName))
  add(query_594126, "api-version", newJString(apiVersion))
  add(path_594125, "name", newJString(name))
  add(query_594126, "details", newJBool(details))
  add(path_594125, "subscriptionId", newJString(subscriptionId))
  add(query_594126, "$filter", newJString(Filter))
  result = call_594124.call(path_594125, query_594126, nil, nil, nil)

var appServicePlansListMetrics* = Call_AppServicePlansListMetrics_594113(
    name: "appServicePlansListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/metrics",
    validator: validate_AppServicePlansListMetrics_594114, base: "",
    url: url_AppServicePlansListMetrics_594115, schemes: {Scheme.Https})
type
  Call_AppServicePlansRestartWebApps_594127 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansRestartWebApps_594129(protocol: Scheme; host: string;
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

proc validate_AppServicePlansRestartWebApps_594128(path: JsonNode; query: JsonNode;
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
  var valid_594130 = path.getOrDefault("resourceGroupName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "resourceGroupName", valid_594130
  var valid_594131 = path.getOrDefault("name")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "name", valid_594131
  var valid_594132 = path.getOrDefault("subscriptionId")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "subscriptionId", valid_594132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   softRestart: JBool
  ##              : Specify <code>true</code> to perform a soft restart, applies the configuration settings and restarts the apps if necessary. The default is <code>false</code>, which always restarts and reprovisions the apps
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594133 = query.getOrDefault("api-version")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "api-version", valid_594133
  var valid_594134 = query.getOrDefault("softRestart")
  valid_594134 = validateParameter(valid_594134, JBool, required = false, default = nil)
  if valid_594134 != nil:
    section.add "softRestart", valid_594134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594135: Call_AppServicePlansRestartWebApps_594127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restart all apps in an App Service plan.
  ## 
  let valid = call_594135.validator(path, query, header, formData, body)
  let scheme = call_594135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594135.url(scheme.get, call_594135.host, call_594135.base,
                         call_594135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594135, url, valid)

proc call*(call_594136: Call_AppServicePlansRestartWebApps_594127;
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
  var path_594137 = newJObject()
  var query_594138 = newJObject()
  add(path_594137, "resourceGroupName", newJString(resourceGroupName))
  add(query_594138, "api-version", newJString(apiVersion))
  add(path_594137, "name", newJString(name))
  add(path_594137, "subscriptionId", newJString(subscriptionId))
  add(query_594138, "softRestart", newJBool(softRestart))
  result = call_594136.call(path_594137, query_594138, nil, nil, nil)

var appServicePlansRestartWebApps* = Call_AppServicePlansRestartWebApps_594127(
    name: "appServicePlansRestartWebApps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/restartSites",
    validator: validate_AppServicePlansRestartWebApps_594128, base: "",
    url: url_AppServicePlansRestartWebApps_594129, schemes: {Scheme.Https})
type
  Call_AppServicePlansListWebApps_594139 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansListWebApps_594141(protocol: Scheme; host: string;
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

proc validate_AppServicePlansListWebApps_594140(path: JsonNode; query: JsonNode;
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
  var valid_594142 = path.getOrDefault("resourceGroupName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "resourceGroupName", valid_594142
  var valid_594143 = path.getOrDefault("name")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "name", valid_594143
  var valid_594144 = path.getOrDefault("subscriptionId")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "subscriptionId", valid_594144
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
  var valid_594145 = query.getOrDefault("api-version")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "api-version", valid_594145
  var valid_594146 = query.getOrDefault("$top")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "$top", valid_594146
  var valid_594147 = query.getOrDefault("$skipToken")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "$skipToken", valid_594147
  var valid_594148 = query.getOrDefault("$filter")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "$filter", valid_594148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594149: Call_AppServicePlansListWebApps_594139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all apps associated with an App Service plan.
  ## 
  let valid = call_594149.validator(path, query, header, formData, body)
  let scheme = call_594149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594149.url(scheme.get, call_594149.host, call_594149.base,
                         call_594149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594149, url, valid)

proc call*(call_594150: Call_AppServicePlansListWebApps_594139;
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
  var path_594151 = newJObject()
  var query_594152 = newJObject()
  add(path_594151, "resourceGroupName", newJString(resourceGroupName))
  add(query_594152, "api-version", newJString(apiVersion))
  add(path_594151, "name", newJString(name))
  add(path_594151, "subscriptionId", newJString(subscriptionId))
  add(query_594152, "$top", newJString(Top))
  add(query_594152, "$skipToken", newJString(SkipToken))
  add(query_594152, "$filter", newJString(Filter))
  result = call_594150.call(path_594151, query_594152, nil, nil, nil)

var appServicePlansListWebApps* = Call_AppServicePlansListWebApps_594139(
    name: "appServicePlansListWebApps", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/sites",
    validator: validate_AppServicePlansListWebApps_594140, base: "",
    url: url_AppServicePlansListWebApps_594141, schemes: {Scheme.Https})
type
  Call_AppServicePlansGetServerFarmSkus_594153 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansGetServerFarmSkus_594155(protocol: Scheme; host: string;
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

proc validate_AppServicePlansGetServerFarmSkus_594154(path: JsonNode;
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
  var valid_594156 = path.getOrDefault("resourceGroupName")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "resourceGroupName", valid_594156
  var valid_594157 = path.getOrDefault("name")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "name", valid_594157
  var valid_594158 = path.getOrDefault("subscriptionId")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "subscriptionId", valid_594158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594159 = query.getOrDefault("api-version")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "api-version", valid_594159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594160: Call_AppServicePlansGetServerFarmSkus_594153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all selectable SKUs for a given App Service Plan
  ## 
  let valid = call_594160.validator(path, query, header, formData, body)
  let scheme = call_594160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594160.url(scheme.get, call_594160.host, call_594160.base,
                         call_594160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594160, url, valid)

proc call*(call_594161: Call_AppServicePlansGetServerFarmSkus_594153;
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
  var path_594162 = newJObject()
  var query_594163 = newJObject()
  add(path_594162, "resourceGroupName", newJString(resourceGroupName))
  add(query_594163, "api-version", newJString(apiVersion))
  add(path_594162, "name", newJString(name))
  add(path_594162, "subscriptionId", newJString(subscriptionId))
  result = call_594161.call(path_594162, query_594163, nil, nil, nil)

var appServicePlansGetServerFarmSkus* = Call_AppServicePlansGetServerFarmSkus_594153(
    name: "appServicePlansGetServerFarmSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/skus",
    validator: validate_AppServicePlansGetServerFarmSkus_594154, base: "",
    url: url_AppServicePlansGetServerFarmSkus_594155, schemes: {Scheme.Https})
type
  Call_AppServicePlansListUsages_594164 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansListUsages_594166(protocol: Scheme; host: string;
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

proc validate_AppServicePlansListUsages_594165(path: JsonNode; query: JsonNode;
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
  var valid_594167 = path.getOrDefault("resourceGroupName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "resourceGroupName", valid_594167
  var valid_594168 = path.getOrDefault("name")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "name", valid_594168
  var valid_594169 = path.getOrDefault("subscriptionId")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "subscriptionId", valid_594169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2').
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594170 = query.getOrDefault("api-version")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "api-version", valid_594170
  var valid_594171 = query.getOrDefault("$filter")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "$filter", valid_594171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594172: Call_AppServicePlansListUsages_594164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets server farm usage information
  ## 
  let valid = call_594172.validator(path, query, header, formData, body)
  let scheme = call_594172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594172.url(scheme.get, call_594172.host, call_594172.base,
                         call_594172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594172, url, valid)

proc call*(call_594173: Call_AppServicePlansListUsages_594164;
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
  var path_594174 = newJObject()
  var query_594175 = newJObject()
  add(path_594174, "resourceGroupName", newJString(resourceGroupName))
  add(query_594175, "api-version", newJString(apiVersion))
  add(path_594174, "name", newJString(name))
  add(path_594174, "subscriptionId", newJString(subscriptionId))
  add(query_594175, "$filter", newJString(Filter))
  result = call_594173.call(path_594174, query_594175, nil, nil, nil)

var appServicePlansListUsages* = Call_AppServicePlansListUsages_594164(
    name: "appServicePlansListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/usages",
    validator: validate_AppServicePlansListUsages_594165, base: "",
    url: url_AppServicePlansListUsages_594166, schemes: {Scheme.Https})
type
  Call_AppServicePlansListVnets_594176 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansListVnets_594178(protocol: Scheme; host: string;
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

proc validate_AppServicePlansListVnets_594177(path: JsonNode; query: JsonNode;
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
  var valid_594179 = path.getOrDefault("resourceGroupName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "resourceGroupName", valid_594179
  var valid_594180 = path.getOrDefault("name")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "name", valid_594180
  var valid_594181 = path.getOrDefault("subscriptionId")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "subscriptionId", valid_594181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594182 = query.getOrDefault("api-version")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "api-version", valid_594182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594183: Call_AppServicePlansListVnets_594176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Virtual Networks associated with an App Service plan.
  ## 
  let valid = call_594183.validator(path, query, header, formData, body)
  let scheme = call_594183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594183.url(scheme.get, call_594183.host, call_594183.base,
                         call_594183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594183, url, valid)

proc call*(call_594184: Call_AppServicePlansListVnets_594176;
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
  var path_594185 = newJObject()
  var query_594186 = newJObject()
  add(path_594185, "resourceGroupName", newJString(resourceGroupName))
  add(query_594186, "api-version", newJString(apiVersion))
  add(path_594185, "name", newJString(name))
  add(path_594185, "subscriptionId", newJString(subscriptionId))
  result = call_594184.call(path_594185, query_594186, nil, nil, nil)

var appServicePlansListVnets* = Call_AppServicePlansListVnets_594176(
    name: "appServicePlansListVnets", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections",
    validator: validate_AppServicePlansListVnets_594177, base: "",
    url: url_AppServicePlansListVnets_594178, schemes: {Scheme.Https})
type
  Call_AppServicePlansGetVnetFromServerFarm_594187 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansGetVnetFromServerFarm_594189(protocol: Scheme;
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

proc validate_AppServicePlansGetVnetFromServerFarm_594188(path: JsonNode;
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
  var valid_594190 = path.getOrDefault("resourceGroupName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "resourceGroupName", valid_594190
  var valid_594191 = path.getOrDefault("name")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "name", valid_594191
  var valid_594192 = path.getOrDefault("vnetName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "vnetName", valid_594192
  var valid_594193 = path.getOrDefault("subscriptionId")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "subscriptionId", valid_594193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594194 = query.getOrDefault("api-version")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "api-version", valid_594194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594195: Call_AppServicePlansGetVnetFromServerFarm_594187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a Virtual Network associated with an App Service plan.
  ## 
  let valid = call_594195.validator(path, query, header, formData, body)
  let scheme = call_594195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594195.url(scheme.get, call_594195.host, call_594195.base,
                         call_594195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594195, url, valid)

proc call*(call_594196: Call_AppServicePlansGetVnetFromServerFarm_594187;
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
  var path_594197 = newJObject()
  var query_594198 = newJObject()
  add(path_594197, "resourceGroupName", newJString(resourceGroupName))
  add(query_594198, "api-version", newJString(apiVersion))
  add(path_594197, "name", newJString(name))
  add(path_594197, "vnetName", newJString(vnetName))
  add(path_594197, "subscriptionId", newJString(subscriptionId))
  result = call_594196.call(path_594197, query_594198, nil, nil, nil)

var appServicePlansGetVnetFromServerFarm* = Call_AppServicePlansGetVnetFromServerFarm_594187(
    name: "appServicePlansGetVnetFromServerFarm", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}",
    validator: validate_AppServicePlansGetVnetFromServerFarm_594188, base: "",
    url: url_AppServicePlansGetVnetFromServerFarm_594189, schemes: {Scheme.Https})
type
  Call_AppServicePlansUpdateVnetGateway_594212 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansUpdateVnetGateway_594214(protocol: Scheme; host: string;
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

proc validate_AppServicePlansUpdateVnetGateway_594213(path: JsonNode;
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
  var valid_594215 = path.getOrDefault("resourceGroupName")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "resourceGroupName", valid_594215
  var valid_594216 = path.getOrDefault("name")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "name", valid_594216
  var valid_594217 = path.getOrDefault("vnetName")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "vnetName", valid_594217
  var valid_594218 = path.getOrDefault("gatewayName")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "gatewayName", valid_594218
  var valid_594219 = path.getOrDefault("subscriptionId")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "subscriptionId", valid_594219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594220 = query.getOrDefault("api-version")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "api-version", valid_594220
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

proc call*(call_594222: Call_AppServicePlansUpdateVnetGateway_594212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a Virtual Network gateway.
  ## 
  let valid = call_594222.validator(path, query, header, formData, body)
  let scheme = call_594222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594222.url(scheme.get, call_594222.host, call_594222.base,
                         call_594222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594222, url, valid)

proc call*(call_594223: Call_AppServicePlansUpdateVnetGateway_594212;
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
  var path_594224 = newJObject()
  var query_594225 = newJObject()
  var body_594226 = newJObject()
  add(path_594224, "resourceGroupName", newJString(resourceGroupName))
  if connectionEnvelope != nil:
    body_594226 = connectionEnvelope
  add(path_594224, "name", newJString(name))
  add(path_594224, "vnetName", newJString(vnetName))
  add(query_594225, "api-version", newJString(apiVersion))
  add(path_594224, "gatewayName", newJString(gatewayName))
  add(path_594224, "subscriptionId", newJString(subscriptionId))
  result = call_594223.call(path_594224, query_594225, nil, nil, body_594226)

var appServicePlansUpdateVnetGateway* = Call_AppServicePlansUpdateVnetGateway_594212(
    name: "appServicePlansUpdateVnetGateway", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}/gateways/{gatewayName}",
    validator: validate_AppServicePlansUpdateVnetGateway_594213, base: "",
    url: url_AppServicePlansUpdateVnetGateway_594214, schemes: {Scheme.Https})
type
  Call_AppServicePlansGetVnetGateway_594199 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansGetVnetGateway_594201(protocol: Scheme; host: string;
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

proc validate_AppServicePlansGetVnetGateway_594200(path: JsonNode; query: JsonNode;
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
  var valid_594202 = path.getOrDefault("resourceGroupName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "resourceGroupName", valid_594202
  var valid_594203 = path.getOrDefault("name")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "name", valid_594203
  var valid_594204 = path.getOrDefault("vnetName")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "vnetName", valid_594204
  var valid_594205 = path.getOrDefault("gatewayName")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "gatewayName", valid_594205
  var valid_594206 = path.getOrDefault("subscriptionId")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "subscriptionId", valid_594206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594207 = query.getOrDefault("api-version")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "api-version", valid_594207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594208: Call_AppServicePlansGetVnetGateway_594199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Virtual Network gateway.
  ## 
  let valid = call_594208.validator(path, query, header, formData, body)
  let scheme = call_594208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594208.url(scheme.get, call_594208.host, call_594208.base,
                         call_594208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594208, url, valid)

proc call*(call_594209: Call_AppServicePlansGetVnetGateway_594199;
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
  var path_594210 = newJObject()
  var query_594211 = newJObject()
  add(path_594210, "resourceGroupName", newJString(resourceGroupName))
  add(query_594211, "api-version", newJString(apiVersion))
  add(path_594210, "name", newJString(name))
  add(path_594210, "vnetName", newJString(vnetName))
  add(path_594210, "gatewayName", newJString(gatewayName))
  add(path_594210, "subscriptionId", newJString(subscriptionId))
  result = call_594209.call(path_594210, query_594211, nil, nil, nil)

var appServicePlansGetVnetGateway* = Call_AppServicePlansGetVnetGateway_594199(
    name: "appServicePlansGetVnetGateway", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}/gateways/{gatewayName}",
    validator: validate_AppServicePlansGetVnetGateway_594200, base: "",
    url: url_AppServicePlansGetVnetGateway_594201, schemes: {Scheme.Https})
type
  Call_AppServicePlansListRoutesForVnet_594227 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansListRoutesForVnet_594229(protocol: Scheme; host: string;
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

proc validate_AppServicePlansListRoutesForVnet_594228(path: JsonNode;
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
  var valid_594230 = path.getOrDefault("resourceGroupName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "resourceGroupName", valid_594230
  var valid_594231 = path.getOrDefault("name")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "name", valid_594231
  var valid_594232 = path.getOrDefault("vnetName")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "vnetName", valid_594232
  var valid_594233 = path.getOrDefault("subscriptionId")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "subscriptionId", valid_594233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594234 = query.getOrDefault("api-version")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "api-version", valid_594234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594235: Call_AppServicePlansListRoutesForVnet_594227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all routes that are associated with a Virtual Network in an App Service plan.
  ## 
  let valid = call_594235.validator(path, query, header, formData, body)
  let scheme = call_594235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594235.url(scheme.get, call_594235.host, call_594235.base,
                         call_594235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594235, url, valid)

proc call*(call_594236: Call_AppServicePlansListRoutesForVnet_594227;
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
  var path_594237 = newJObject()
  var query_594238 = newJObject()
  add(path_594237, "resourceGroupName", newJString(resourceGroupName))
  add(query_594238, "api-version", newJString(apiVersion))
  add(path_594237, "name", newJString(name))
  add(path_594237, "vnetName", newJString(vnetName))
  add(path_594237, "subscriptionId", newJString(subscriptionId))
  result = call_594236.call(path_594237, query_594238, nil, nil, nil)

var appServicePlansListRoutesForVnet* = Call_AppServicePlansListRoutesForVnet_594227(
    name: "appServicePlansListRoutesForVnet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}/routes",
    validator: validate_AppServicePlansListRoutesForVnet_594228, base: "",
    url: url_AppServicePlansListRoutesForVnet_594229, schemes: {Scheme.Https})
type
  Call_AppServicePlansCreateOrUpdateVnetRoute_594252 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansCreateOrUpdateVnetRoute_594254(protocol: Scheme;
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

proc validate_AppServicePlansCreateOrUpdateVnetRoute_594253(path: JsonNode;
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
  var valid_594255 = path.getOrDefault("resourceGroupName")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "resourceGroupName", valid_594255
  var valid_594256 = path.getOrDefault("name")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "name", valid_594256
  var valid_594257 = path.getOrDefault("vnetName")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "vnetName", valid_594257
  var valid_594258 = path.getOrDefault("subscriptionId")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "subscriptionId", valid_594258
  var valid_594259 = path.getOrDefault("routeName")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "routeName", valid_594259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594260 = query.getOrDefault("api-version")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "api-version", valid_594260
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

proc call*(call_594262: Call_AppServicePlansCreateOrUpdateVnetRoute_594252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a Virtual Network route in an App Service plan.
  ## 
  let valid = call_594262.validator(path, query, header, formData, body)
  let scheme = call_594262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594262.url(scheme.get, call_594262.host, call_594262.base,
                         call_594262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594262, url, valid)

proc call*(call_594263: Call_AppServicePlansCreateOrUpdateVnetRoute_594252;
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
  var path_594264 = newJObject()
  var query_594265 = newJObject()
  var body_594266 = newJObject()
  add(path_594264, "resourceGroupName", newJString(resourceGroupName))
  add(query_594265, "api-version", newJString(apiVersion))
  add(path_594264, "name", newJString(name))
  add(path_594264, "vnetName", newJString(vnetName))
  add(path_594264, "subscriptionId", newJString(subscriptionId))
  add(path_594264, "routeName", newJString(routeName))
  if route != nil:
    body_594266 = route
  result = call_594263.call(path_594264, query_594265, nil, nil, body_594266)

var appServicePlansCreateOrUpdateVnetRoute* = Call_AppServicePlansCreateOrUpdateVnetRoute_594252(
    name: "appServicePlansCreateOrUpdateVnetRoute", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}/routes/{routeName}",
    validator: validate_AppServicePlansCreateOrUpdateVnetRoute_594253, base: "",
    url: url_AppServicePlansCreateOrUpdateVnetRoute_594254,
    schemes: {Scheme.Https})
type
  Call_AppServicePlansGetRouteForVnet_594239 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansGetRouteForVnet_594241(protocol: Scheme; host: string;
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

proc validate_AppServicePlansGetRouteForVnet_594240(path: JsonNode;
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
  var valid_594242 = path.getOrDefault("resourceGroupName")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "resourceGroupName", valid_594242
  var valid_594243 = path.getOrDefault("name")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "name", valid_594243
  var valid_594244 = path.getOrDefault("vnetName")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "vnetName", valid_594244
  var valid_594245 = path.getOrDefault("subscriptionId")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "subscriptionId", valid_594245
  var valid_594246 = path.getOrDefault("routeName")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "routeName", valid_594246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594247 = query.getOrDefault("api-version")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "api-version", valid_594247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594248: Call_AppServicePlansGetRouteForVnet_594239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Virtual Network route in an App Service plan.
  ## 
  let valid = call_594248.validator(path, query, header, formData, body)
  let scheme = call_594248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594248.url(scheme.get, call_594248.host, call_594248.base,
                         call_594248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594248, url, valid)

proc call*(call_594249: Call_AppServicePlansGetRouteForVnet_594239;
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
  var path_594250 = newJObject()
  var query_594251 = newJObject()
  add(path_594250, "resourceGroupName", newJString(resourceGroupName))
  add(query_594251, "api-version", newJString(apiVersion))
  add(path_594250, "name", newJString(name))
  add(path_594250, "vnetName", newJString(vnetName))
  add(path_594250, "subscriptionId", newJString(subscriptionId))
  add(path_594250, "routeName", newJString(routeName))
  result = call_594249.call(path_594250, query_594251, nil, nil, nil)

var appServicePlansGetRouteForVnet* = Call_AppServicePlansGetRouteForVnet_594239(
    name: "appServicePlansGetRouteForVnet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}/routes/{routeName}",
    validator: validate_AppServicePlansGetRouteForVnet_594240, base: "",
    url: url_AppServicePlansGetRouteForVnet_594241, schemes: {Scheme.Https})
type
  Call_AppServicePlansUpdateVnetRoute_594280 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansUpdateVnetRoute_594282(protocol: Scheme; host: string;
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

proc validate_AppServicePlansUpdateVnetRoute_594281(path: JsonNode;
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
  var valid_594283 = path.getOrDefault("resourceGroupName")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "resourceGroupName", valid_594283
  var valid_594284 = path.getOrDefault("name")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "name", valid_594284
  var valid_594285 = path.getOrDefault("vnetName")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "vnetName", valid_594285
  var valid_594286 = path.getOrDefault("subscriptionId")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "subscriptionId", valid_594286
  var valid_594287 = path.getOrDefault("routeName")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "routeName", valid_594287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594288 = query.getOrDefault("api-version")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "api-version", valid_594288
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

proc call*(call_594290: Call_AppServicePlansUpdateVnetRoute_594280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Virtual Network route in an App Service plan.
  ## 
  let valid = call_594290.validator(path, query, header, formData, body)
  let scheme = call_594290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594290.url(scheme.get, call_594290.host, call_594290.base,
                         call_594290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594290, url, valid)

proc call*(call_594291: Call_AppServicePlansUpdateVnetRoute_594280;
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
  var path_594292 = newJObject()
  var query_594293 = newJObject()
  var body_594294 = newJObject()
  add(path_594292, "resourceGroupName", newJString(resourceGroupName))
  add(query_594293, "api-version", newJString(apiVersion))
  add(path_594292, "name", newJString(name))
  add(path_594292, "vnetName", newJString(vnetName))
  add(path_594292, "subscriptionId", newJString(subscriptionId))
  add(path_594292, "routeName", newJString(routeName))
  if route != nil:
    body_594294 = route
  result = call_594291.call(path_594292, query_594293, nil, nil, body_594294)

var appServicePlansUpdateVnetRoute* = Call_AppServicePlansUpdateVnetRoute_594280(
    name: "appServicePlansUpdateVnetRoute", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}/routes/{routeName}",
    validator: validate_AppServicePlansUpdateVnetRoute_594281, base: "",
    url: url_AppServicePlansUpdateVnetRoute_594282, schemes: {Scheme.Https})
type
  Call_AppServicePlansDeleteVnetRoute_594267 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansDeleteVnetRoute_594269(protocol: Scheme; host: string;
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

proc validate_AppServicePlansDeleteVnetRoute_594268(path: JsonNode;
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
  var valid_594270 = path.getOrDefault("resourceGroupName")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "resourceGroupName", valid_594270
  var valid_594271 = path.getOrDefault("name")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "name", valid_594271
  var valid_594272 = path.getOrDefault("vnetName")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "vnetName", valid_594272
  var valid_594273 = path.getOrDefault("subscriptionId")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "subscriptionId", valid_594273
  var valid_594274 = path.getOrDefault("routeName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "routeName", valid_594274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594275 = query.getOrDefault("api-version")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "api-version", valid_594275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594276: Call_AppServicePlansDeleteVnetRoute_594267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Virtual Network route in an App Service plan.
  ## 
  let valid = call_594276.validator(path, query, header, formData, body)
  let scheme = call_594276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594276.url(scheme.get, call_594276.host, call_594276.base,
                         call_594276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594276, url, valid)

proc call*(call_594277: Call_AppServicePlansDeleteVnetRoute_594267;
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
  var path_594278 = newJObject()
  var query_594279 = newJObject()
  add(path_594278, "resourceGroupName", newJString(resourceGroupName))
  add(query_594279, "api-version", newJString(apiVersion))
  add(path_594278, "name", newJString(name))
  add(path_594278, "vnetName", newJString(vnetName))
  add(path_594278, "subscriptionId", newJString(subscriptionId))
  add(path_594278, "routeName", newJString(routeName))
  result = call_594277.call(path_594278, query_594279, nil, nil, nil)

var appServicePlansDeleteVnetRoute* = Call_AppServicePlansDeleteVnetRoute_594267(
    name: "appServicePlansDeleteVnetRoute", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/virtualNetworkConnections/{vnetName}/routes/{routeName}",
    validator: validate_AppServicePlansDeleteVnetRoute_594268, base: "",
    url: url_AppServicePlansDeleteVnetRoute_594269, schemes: {Scheme.Https})
type
  Call_AppServicePlansRebootWorker_594295 = ref object of OpenApiRestCall_593424
proc url_AppServicePlansRebootWorker_594297(protocol: Scheme; host: string;
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

proc validate_AppServicePlansRebootWorker_594296(path: JsonNode; query: JsonNode;
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
  var valid_594298 = path.getOrDefault("resourceGroupName")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "resourceGroupName", valid_594298
  var valid_594299 = path.getOrDefault("name")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "name", valid_594299
  var valid_594300 = path.getOrDefault("subscriptionId")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "subscriptionId", valid_594300
  var valid_594301 = path.getOrDefault("workerName")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "workerName", valid_594301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594302 = query.getOrDefault("api-version")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "api-version", valid_594302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594303: Call_AppServicePlansRebootWorker_594295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reboot a worker machine in an App Service plan.
  ## 
  let valid = call_594303.validator(path, query, header, formData, body)
  let scheme = call_594303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594303.url(scheme.get, call_594303.host, call_594303.base,
                         call_594303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594303, url, valid)

proc call*(call_594304: Call_AppServicePlansRebootWorker_594295;
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
  var path_594305 = newJObject()
  var query_594306 = newJObject()
  add(path_594305, "resourceGroupName", newJString(resourceGroupName))
  add(query_594306, "api-version", newJString(apiVersion))
  add(path_594305, "name", newJString(name))
  add(path_594305, "subscriptionId", newJString(subscriptionId))
  add(path_594305, "workerName", newJString(workerName))
  result = call_594304.call(path_594305, query_594306, nil, nil, nil)

var appServicePlansRebootWorker* = Call_AppServicePlansRebootWorker_594295(
    name: "appServicePlansRebootWorker", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms/{name}/workers/{workerName}/reboot",
    validator: validate_AppServicePlansRebootWorker_594296, base: "",
    url: url_AppServicePlansRebootWorker_594297, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
