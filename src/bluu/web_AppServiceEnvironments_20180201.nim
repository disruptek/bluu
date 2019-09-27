
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AppServiceEnvironments API Client
## version: 2018-02-01
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

  OpenApiRestCall_593426 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593426](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593426): Option[Scheme] {.used.} =
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
  macServiceName = "web-AppServiceEnvironments"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppServiceEnvironmentsList_593648 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsList_593650(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsList_593649(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all App Service Environments for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593823 = path.getOrDefault("subscriptionId")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "subscriptionId", valid_593823
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593824 = query.getOrDefault("api-version")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "api-version", valid_593824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593847: Call_AppServiceEnvironmentsList_593648; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all App Service Environments for a subscription.
  ## 
  let valid = call_593847.validator(path, query, header, formData, body)
  let scheme = call_593847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593847.url(scheme.get, call_593847.host, call_593847.base,
                         call_593847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593847, url, valid)

proc call*(call_593918: Call_AppServiceEnvironmentsList_593648; apiVersion: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsList
  ## Get all App Service Environments for a subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_593919 = newJObject()
  var query_593921 = newJObject()
  add(query_593921, "api-version", newJString(apiVersion))
  add(path_593919, "subscriptionId", newJString(subscriptionId))
  result = call_593918.call(path_593919, query_593921, nil, nil, nil)

var appServiceEnvironmentsList* = Call_AppServiceEnvironmentsList_593648(
    name: "appServiceEnvironmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/hostingEnvironments",
    validator: validate_AppServiceEnvironmentsList_593649, base: "",
    url: url_AppServiceEnvironmentsList_593650, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListByResourceGroup_593960 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListByResourceGroup_593962(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListByResourceGroup_593961(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all App Service Environments in a resource group.
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
  var valid_593963 = path.getOrDefault("resourceGroupName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "resourceGroupName", valid_593963
  var valid_593964 = path.getOrDefault("subscriptionId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "subscriptionId", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_AppServiceEnvironmentsListByResourceGroup_593960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all App Service Environments in a resource group.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_AppServiceEnvironmentsListByResourceGroup_593960;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListByResourceGroup
  ## Get all App Service Environments in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_593968 = newJObject()
  var query_593969 = newJObject()
  add(path_593968, "resourceGroupName", newJString(resourceGroupName))
  add(query_593969, "api-version", newJString(apiVersion))
  add(path_593968, "subscriptionId", newJString(subscriptionId))
  result = call_593967.call(path_593968, query_593969, nil, nil, nil)

var appServiceEnvironmentsListByResourceGroup* = Call_AppServiceEnvironmentsListByResourceGroup_593960(
    name: "appServiceEnvironmentsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments",
    validator: validate_AppServiceEnvironmentsListByResourceGroup_593961,
    base: "", url: url_AppServiceEnvironmentsListByResourceGroup_593962,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsCreateOrUpdate_593981 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsCreateOrUpdate_593983(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsCreateOrUpdate_593982(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593984 = path.getOrDefault("resourceGroupName")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "resourceGroupName", valid_593984
  var valid_593985 = path.getOrDefault("name")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "name", valid_593985
  var valid_593986 = path.getOrDefault("subscriptionId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "subscriptionId", valid_593986
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593987 = query.getOrDefault("api-version")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "api-version", valid_593987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   hostingEnvironmentEnvelope: JObject (required)
  ##                             : Configuration details of the App Service Environment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593989: Call_AppServiceEnvironmentsCreateOrUpdate_593981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an App Service Environment.
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_AppServiceEnvironmentsCreateOrUpdate_593981;
          resourceGroupName: string; apiVersion: string; name: string;
          hostingEnvironmentEnvelope: JsonNode; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsCreateOrUpdate
  ## Create or update an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   hostingEnvironmentEnvelope: JObject (required)
  ##                             : Configuration details of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  var body_593993 = newJObject()
  add(path_593991, "resourceGroupName", newJString(resourceGroupName))
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "name", newJString(name))
  if hostingEnvironmentEnvelope != nil:
    body_593993 = hostingEnvironmentEnvelope
  add(path_593991, "subscriptionId", newJString(subscriptionId))
  result = call_593990.call(path_593991, query_593992, nil, nil, body_593993)

var appServiceEnvironmentsCreateOrUpdate* = Call_AppServiceEnvironmentsCreateOrUpdate_593981(
    name: "appServiceEnvironmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsCreateOrUpdate_593982, base: "",
    url: url_AppServiceEnvironmentsCreateOrUpdate_593983, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGet_593970 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsGet_593972(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsGet_593971(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the properties of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593973 = path.getOrDefault("resourceGroupName")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "resourceGroupName", valid_593973
  var valid_593974 = path.getOrDefault("name")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "name", valid_593974
  var valid_593975 = path.getOrDefault("subscriptionId")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "subscriptionId", valid_593975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593977: Call_AppServiceEnvironmentsGet_593970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the properties of an App Service Environment.
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_AppServiceEnvironmentsGet_593970;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsGet
  ## Get the properties of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_593979 = newJObject()
  var query_593980 = newJObject()
  add(path_593979, "resourceGroupName", newJString(resourceGroupName))
  add(query_593980, "api-version", newJString(apiVersion))
  add(path_593979, "name", newJString(name))
  add(path_593979, "subscriptionId", newJString(subscriptionId))
  result = call_593978.call(path_593979, query_593980, nil, nil, nil)

var appServiceEnvironmentsGet* = Call_AppServiceEnvironmentsGet_593970(
    name: "appServiceEnvironmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsGet_593971, base: "",
    url: url_AppServiceEnvironmentsGet_593972, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsUpdate_594006 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsUpdate_594008(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsUpdate_594007(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594009 = path.getOrDefault("resourceGroupName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "resourceGroupName", valid_594009
  var valid_594010 = path.getOrDefault("name")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "name", valid_594010
  var valid_594011 = path.getOrDefault("subscriptionId")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "subscriptionId", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "api-version", valid_594012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   hostingEnvironmentEnvelope: JObject (required)
  ##                             : Configuration details of the App Service Environment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594014: Call_AppServiceEnvironmentsUpdate_594006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an App Service Environment.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_AppServiceEnvironmentsUpdate_594006;
          resourceGroupName: string; apiVersion: string; name: string;
          hostingEnvironmentEnvelope: JsonNode; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsUpdate
  ## Create or update an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   hostingEnvironmentEnvelope: JObject (required)
  ##                             : Configuration details of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  var body_594018 = newJObject()
  add(path_594016, "resourceGroupName", newJString(resourceGroupName))
  add(query_594017, "api-version", newJString(apiVersion))
  add(path_594016, "name", newJString(name))
  if hostingEnvironmentEnvelope != nil:
    body_594018 = hostingEnvironmentEnvelope
  add(path_594016, "subscriptionId", newJString(subscriptionId))
  result = call_594015.call(path_594016, query_594017, nil, nil, body_594018)

var appServiceEnvironmentsUpdate* = Call_AppServiceEnvironmentsUpdate_594006(
    name: "appServiceEnvironmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsUpdate_594007, base: "",
    url: url_AppServiceEnvironmentsUpdate_594008, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsDelete_593994 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsDelete_593996(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsDelete_593995(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593997 = path.getOrDefault("resourceGroupName")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "resourceGroupName", valid_593997
  var valid_593998 = path.getOrDefault("name")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "name", valid_593998
  var valid_593999 = path.getOrDefault("subscriptionId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "subscriptionId", valid_593999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   forceDelete: JBool
  ##              : Specify <code>true</code> to force the deletion even if the App Service Environment contains resources. The default is <code>false</code>.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594000 = query.getOrDefault("api-version")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "api-version", valid_594000
  var valid_594001 = query.getOrDefault("forceDelete")
  valid_594001 = validateParameter(valid_594001, JBool, required = false, default = nil)
  if valid_594001 != nil:
    section.add "forceDelete", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_AppServiceEnvironmentsDelete_593994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an App Service Environment.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_AppServiceEnvironmentsDelete_593994;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; forceDelete: bool = false): Recallable =
  ## appServiceEnvironmentsDelete
  ## Delete an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   forceDelete: bool
  ##              : Specify <code>true</code> to force the deletion even if the App Service Environment contains resources. The default is <code>false</code>.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  add(path_594004, "resourceGroupName", newJString(resourceGroupName))
  add(query_594005, "api-version", newJString(apiVersion))
  add(path_594004, "name", newJString(name))
  add(query_594005, "forceDelete", newJBool(forceDelete))
  add(path_594004, "subscriptionId", newJString(subscriptionId))
  result = call_594003.call(path_594004, query_594005, nil, nil, nil)

var appServiceEnvironmentsDelete* = Call_AppServiceEnvironmentsDelete_593994(
    name: "appServiceEnvironmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}",
    validator: validate_AppServiceEnvironmentsDelete_593995, base: "",
    url: url_AppServiceEnvironmentsDelete_593996, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListCapacities_594019 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListCapacities_594021(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/capacities/compute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListCapacities_594020(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the used, available, and total worker capacity an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594022 = path.getOrDefault("resourceGroupName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "resourceGroupName", valid_594022
  var valid_594023 = path.getOrDefault("name")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "name", valid_594023
  var valid_594024 = path.getOrDefault("subscriptionId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "subscriptionId", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "api-version", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_AppServiceEnvironmentsListCapacities_594019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the used, available, and total worker capacity an App Service Environment.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_AppServiceEnvironmentsListCapacities_594019;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListCapacities
  ## Get the used, available, and total worker capacity an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(path_594028, "resourceGroupName", newJString(resourceGroupName))
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "name", newJString(name))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var appServiceEnvironmentsListCapacities* = Call_AppServiceEnvironmentsListCapacities_594019(
    name: "appServiceEnvironmentsListCapacities", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/capacities/compute",
    validator: validate_AppServiceEnvironmentsListCapacities_594020, base: "",
    url: url_AppServiceEnvironmentsListCapacities_594021, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListVips_594030 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListVips_594032(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/capacities/virtualip")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListVips_594031(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get IP addresses assigned to an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594033 = path.getOrDefault("resourceGroupName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "resourceGroupName", valid_594033
  var valid_594034 = path.getOrDefault("name")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "name", valid_594034
  var valid_594035 = path.getOrDefault("subscriptionId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "subscriptionId", valid_594035
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

proc call*(call_594037: Call_AppServiceEnvironmentsListVips_594030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get IP addresses assigned to an App Service Environment.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_AppServiceEnvironmentsListVips_594030;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListVips
  ## Get IP addresses assigned to an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  add(path_594039, "resourceGroupName", newJString(resourceGroupName))
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "name", newJString(name))
  add(path_594039, "subscriptionId", newJString(subscriptionId))
  result = call_594038.call(path_594039, query_594040, nil, nil, nil)

var appServiceEnvironmentsListVips* = Call_AppServiceEnvironmentsListVips_594030(
    name: "appServiceEnvironmentsListVips", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/capacities/virtualip",
    validator: validate_AppServiceEnvironmentsListVips_594031, base: "",
    url: url_AppServiceEnvironmentsListVips_594032, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsChangeVnet_594041 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsChangeVnet_594043(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/changeVirtualNetwork")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsChangeVnet_594042(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Move an App Service Environment to a different VNET.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594044 = path.getOrDefault("resourceGroupName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "resourceGroupName", valid_594044
  var valid_594045 = path.getOrDefault("name")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "name", valid_594045
  var valid_594046 = path.getOrDefault("subscriptionId")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "subscriptionId", valid_594046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594047 = query.getOrDefault("api-version")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "api-version", valid_594047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vnetInfo: JObject (required)
  ##           : Details for the new virtual network.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594049: Call_AppServiceEnvironmentsChangeVnet_594041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Move an App Service Environment to a different VNET.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_AppServiceEnvironmentsChangeVnet_594041;
          resourceGroupName: string; vnetInfo: JsonNode; apiVersion: string;
          name: string; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsChangeVnet
  ## Move an App Service Environment to a different VNET.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   vnetInfo: JObject (required)
  ##           : Details for the new virtual network.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  var body_594053 = newJObject()
  add(path_594051, "resourceGroupName", newJString(resourceGroupName))
  if vnetInfo != nil:
    body_594053 = vnetInfo
  add(query_594052, "api-version", newJString(apiVersion))
  add(path_594051, "name", newJString(name))
  add(path_594051, "subscriptionId", newJString(subscriptionId))
  result = call_594050.call(path_594051, query_594052, nil, nil, body_594053)

var appServiceEnvironmentsChangeVnet* = Call_AppServiceEnvironmentsChangeVnet_594041(
    name: "appServiceEnvironmentsChangeVnet", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/changeVirtualNetwork",
    validator: validate_AppServiceEnvironmentsChangeVnet_594042, base: "",
    url: url_AppServiceEnvironmentsChangeVnet_594043, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListDiagnostics_594054 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListDiagnostics_594056(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/diagnostics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListDiagnostics_594055(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get diagnostic information for an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594057 = path.getOrDefault("resourceGroupName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "resourceGroupName", valid_594057
  var valid_594058 = path.getOrDefault("name")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "name", valid_594058
  var valid_594059 = path.getOrDefault("subscriptionId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "subscriptionId", valid_594059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594060 = query.getOrDefault("api-version")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "api-version", valid_594060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594061: Call_AppServiceEnvironmentsListDiagnostics_594054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get diagnostic information for an App Service Environment.
  ## 
  let valid = call_594061.validator(path, query, header, formData, body)
  let scheme = call_594061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594061.url(scheme.get, call_594061.host, call_594061.base,
                         call_594061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594061, url, valid)

proc call*(call_594062: Call_AppServiceEnvironmentsListDiagnostics_594054;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListDiagnostics
  ## Get diagnostic information for an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594063 = newJObject()
  var query_594064 = newJObject()
  add(path_594063, "resourceGroupName", newJString(resourceGroupName))
  add(query_594064, "api-version", newJString(apiVersion))
  add(path_594063, "name", newJString(name))
  add(path_594063, "subscriptionId", newJString(subscriptionId))
  result = call_594062.call(path_594063, query_594064, nil, nil, nil)

var appServiceEnvironmentsListDiagnostics* = Call_AppServiceEnvironmentsListDiagnostics_594054(
    name: "appServiceEnvironmentsListDiagnostics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/diagnostics",
    validator: validate_AppServiceEnvironmentsListDiagnostics_594055, base: "",
    url: url_AppServiceEnvironmentsListDiagnostics_594056, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetDiagnosticsItem_594065 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsGetDiagnosticsItem_594067(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "diagnosticsName" in path, "`diagnosticsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsGetDiagnosticsItem_594066(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a diagnostics item for an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   diagnosticsName: JString (required)
  ##                  : Name of the diagnostics item.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594068 = path.getOrDefault("resourceGroupName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "resourceGroupName", valid_594068
  var valid_594069 = path.getOrDefault("name")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "name", valid_594069
  var valid_594070 = path.getOrDefault("subscriptionId")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "subscriptionId", valid_594070
  var valid_594071 = path.getOrDefault("diagnosticsName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "diagnosticsName", valid_594071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594072 = query.getOrDefault("api-version")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "api-version", valid_594072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_AppServiceEnvironmentsGetDiagnosticsItem_594065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a diagnostics item for an App Service Environment.
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_AppServiceEnvironmentsGetDiagnosticsItem_594065;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; diagnosticsName: string): Recallable =
  ## appServiceEnvironmentsGetDiagnosticsItem
  ## Get a diagnostics item for an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   diagnosticsName: string (required)
  ##                  : Name of the diagnostics item.
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  add(path_594075, "resourceGroupName", newJString(resourceGroupName))
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "name", newJString(name))
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  add(path_594075, "diagnosticsName", newJString(diagnosticsName))
  result = call_594074.call(path_594075, query_594076, nil, nil, nil)

var appServiceEnvironmentsGetDiagnosticsItem* = Call_AppServiceEnvironmentsGetDiagnosticsItem_594065(
    name: "appServiceEnvironmentsGetDiagnosticsItem", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/diagnostics/{diagnosticsName}",
    validator: validate_AppServiceEnvironmentsGetDiagnosticsItem_594066, base: "",
    url: url_AppServiceEnvironmentsGetDiagnosticsItem_594067,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_594077 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_594079(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"), (kind: ConstantSegment,
        value: "/inboundNetworkDependenciesEndpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_594078(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the network endpoints of all inbound dependencies of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594080 = path.getOrDefault("resourceGroupName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "resourceGroupName", valid_594080
  var valid_594081 = path.getOrDefault("name")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "name", valid_594081
  var valid_594082 = path.getOrDefault("subscriptionId")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "subscriptionId", valid_594082
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594083 = query.getOrDefault("api-version")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "api-version", valid_594083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594084: Call_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_594077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the network endpoints of all inbound dependencies of an App Service Environment.
  ## 
  let valid = call_594084.validator(path, query, header, formData, body)
  let scheme = call_594084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594084.url(scheme.get, call_594084.host, call_594084.base,
                         call_594084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594084, url, valid)

proc call*(call_594085: Call_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_594077;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsGetInboundNetworkDependenciesEndpoints
  ## Get the network endpoints of all inbound dependencies of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594086 = newJObject()
  var query_594087 = newJObject()
  add(path_594086, "resourceGroupName", newJString(resourceGroupName))
  add(query_594087, "api-version", newJString(apiVersion))
  add(path_594086, "name", newJString(name))
  add(path_594086, "subscriptionId", newJString(subscriptionId))
  result = call_594085.call(path_594086, query_594087, nil, nil, nil)

var appServiceEnvironmentsGetInboundNetworkDependenciesEndpoints* = Call_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_594077(
    name: "appServiceEnvironmentsGetInboundNetworkDependenciesEndpoints",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/inboundNetworkDependenciesEndpoints", validator: validate_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_594078,
    base: "",
    url: url_AppServiceEnvironmentsGetInboundNetworkDependenciesEndpoints_594079,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMetricDefinitions_594088 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListMetricDefinitions_594090(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/metricdefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMetricDefinitions_594089(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get global metric definitions of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594091 = path.getOrDefault("resourceGroupName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "resourceGroupName", valid_594091
  var valid_594092 = path.getOrDefault("name")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "name", valid_594092
  var valid_594093 = path.getOrDefault("subscriptionId")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "subscriptionId", valid_594093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594094 = query.getOrDefault("api-version")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "api-version", valid_594094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594095: Call_AppServiceEnvironmentsListMetricDefinitions_594088;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get global metric definitions of an App Service Environment.
  ## 
  let valid = call_594095.validator(path, query, header, formData, body)
  let scheme = call_594095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594095.url(scheme.get, call_594095.host, call_594095.base,
                         call_594095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594095, url, valid)

proc call*(call_594096: Call_AppServiceEnvironmentsListMetricDefinitions_594088;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListMetricDefinitions
  ## Get global metric definitions of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594097 = newJObject()
  var query_594098 = newJObject()
  add(path_594097, "resourceGroupName", newJString(resourceGroupName))
  add(query_594098, "api-version", newJString(apiVersion))
  add(path_594097, "name", newJString(name))
  add(path_594097, "subscriptionId", newJString(subscriptionId))
  result = call_594096.call(path_594097, query_594098, nil, nil, nil)

var appServiceEnvironmentsListMetricDefinitions* = Call_AppServiceEnvironmentsListMetricDefinitions_594088(
    name: "appServiceEnvironmentsListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/metricdefinitions",
    validator: validate_AppServiceEnvironmentsListMetricDefinitions_594089,
    base: "", url: url_AppServiceEnvironmentsListMetricDefinitions_594090,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMetrics_594099 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListMetrics_594101(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMetrics_594100(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get global metrics of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594103 = path.getOrDefault("resourceGroupName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "resourceGroupName", valid_594103
  var valid_594104 = path.getOrDefault("name")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "name", valid_594104
  var valid_594105 = path.getOrDefault("subscriptionId")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "subscriptionId", valid_594105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594106 = query.getOrDefault("api-version")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "api-version", valid_594106
  var valid_594107 = query.getOrDefault("details")
  valid_594107 = validateParameter(valid_594107, JBool, required = false, default = nil)
  if valid_594107 != nil:
    section.add "details", valid_594107
  var valid_594108 = query.getOrDefault("$filter")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "$filter", valid_594108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594109: Call_AppServiceEnvironmentsListMetrics_594099;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get global metrics of an App Service Environment.
  ## 
  let valid = call_594109.validator(path, query, header, formData, body)
  let scheme = call_594109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594109.url(scheme.get, call_594109.host, call_594109.base,
                         call_594109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594109, url, valid)

proc call*(call_594110: Call_AppServiceEnvironmentsListMetrics_594099;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; details: bool = false; Filter: string = ""): Recallable =
  ## appServiceEnvironmentsListMetrics
  ## Get global metrics of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_594111 = newJObject()
  var query_594112 = newJObject()
  add(path_594111, "resourceGroupName", newJString(resourceGroupName))
  add(query_594112, "api-version", newJString(apiVersion))
  add(path_594111, "name", newJString(name))
  add(query_594112, "details", newJBool(details))
  add(path_594111, "subscriptionId", newJString(subscriptionId))
  add(query_594112, "$filter", newJString(Filter))
  result = call_594110.call(path_594111, query_594112, nil, nil, nil)

var appServiceEnvironmentsListMetrics* = Call_AppServiceEnvironmentsListMetrics_594099(
    name: "appServiceEnvironmentsListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/metrics",
    validator: validate_AppServiceEnvironmentsListMetrics_594100, base: "",
    url: url_AppServiceEnvironmentsListMetrics_594101, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePools_594113 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListMultiRolePools_594115(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/multiRolePools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMultiRolePools_594114(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all multi-role pools.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594116 = path.getOrDefault("resourceGroupName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "resourceGroupName", valid_594116
  var valid_594117 = path.getOrDefault("name")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "name", valid_594117
  var valid_594118 = path.getOrDefault("subscriptionId")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "subscriptionId", valid_594118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594119 = query.getOrDefault("api-version")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "api-version", valid_594119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594120: Call_AppServiceEnvironmentsListMultiRolePools_594113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all multi-role pools.
  ## 
  let valid = call_594120.validator(path, query, header, formData, body)
  let scheme = call_594120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594120.url(scheme.get, call_594120.host, call_594120.base,
                         call_594120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594120, url, valid)

proc call*(call_594121: Call_AppServiceEnvironmentsListMultiRolePools_594113;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListMultiRolePools
  ## Get all multi-role pools.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594122 = newJObject()
  var query_594123 = newJObject()
  add(path_594122, "resourceGroupName", newJString(resourceGroupName))
  add(query_594123, "api-version", newJString(apiVersion))
  add(path_594122, "name", newJString(name))
  add(path_594122, "subscriptionId", newJString(subscriptionId))
  result = call_594121.call(path_594122, query_594123, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePools* = Call_AppServiceEnvironmentsListMultiRolePools_594113(
    name: "appServiceEnvironmentsListMultiRolePools", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools",
    validator: validate_AppServiceEnvironmentsListMultiRolePools_594114, base: "",
    url: url_AppServiceEnvironmentsListMultiRolePools_594115,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_594135 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_594137(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/multiRolePools/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_594136(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update a multi-role pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594138 = path.getOrDefault("resourceGroupName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "resourceGroupName", valid_594138
  var valid_594139 = path.getOrDefault("name")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "name", valid_594139
  var valid_594140 = path.getOrDefault("subscriptionId")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "subscriptionId", valid_594140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594141 = query.getOrDefault("api-version")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "api-version", valid_594141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   multiRolePoolEnvelope: JObject (required)
  ##                        : Properties of the multi-role pool.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594143: Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_594135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a multi-role pool.
  ## 
  let valid = call_594143.validator(path, query, header, formData, body)
  let scheme = call_594143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594143.url(scheme.get, call_594143.host, call_594143.base,
                         call_594143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594143, url, valid)

proc call*(call_594144: Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_594135;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; multiRolePoolEnvelope: JsonNode): Recallable =
  ## appServiceEnvironmentsCreateOrUpdateMultiRolePool
  ## Create or update a multi-role pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   multiRolePoolEnvelope: JObject (required)
  ##                        : Properties of the multi-role pool.
  var path_594145 = newJObject()
  var query_594146 = newJObject()
  var body_594147 = newJObject()
  add(path_594145, "resourceGroupName", newJString(resourceGroupName))
  add(query_594146, "api-version", newJString(apiVersion))
  add(path_594145, "name", newJString(name))
  add(path_594145, "subscriptionId", newJString(subscriptionId))
  if multiRolePoolEnvelope != nil:
    body_594147 = multiRolePoolEnvelope
  result = call_594144.call(path_594145, query_594146, nil, nil, body_594147)

var appServiceEnvironmentsCreateOrUpdateMultiRolePool* = Call_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_594135(
    name: "appServiceEnvironmentsCreateOrUpdateMultiRolePool",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default",
    validator: validate_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_594136,
    base: "", url: url_AppServiceEnvironmentsCreateOrUpdateMultiRolePool_594137,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetMultiRolePool_594124 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsGetMultiRolePool_594126(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/multiRolePools/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsGetMultiRolePool_594125(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get properties of a multi-role pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594127 = path.getOrDefault("resourceGroupName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "resourceGroupName", valid_594127
  var valid_594128 = path.getOrDefault("name")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "name", valid_594128
  var valid_594129 = path.getOrDefault("subscriptionId")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "subscriptionId", valid_594129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594130 = query.getOrDefault("api-version")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "api-version", valid_594130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594131: Call_AppServiceEnvironmentsGetMultiRolePool_594124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get properties of a multi-role pool.
  ## 
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_AppServiceEnvironmentsGetMultiRolePool_594124;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsGetMultiRolePool
  ## Get properties of a multi-role pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594133 = newJObject()
  var query_594134 = newJObject()
  add(path_594133, "resourceGroupName", newJString(resourceGroupName))
  add(query_594134, "api-version", newJString(apiVersion))
  add(path_594133, "name", newJString(name))
  add(path_594133, "subscriptionId", newJString(subscriptionId))
  result = call_594132.call(path_594133, query_594134, nil, nil, nil)

var appServiceEnvironmentsGetMultiRolePool* = Call_AppServiceEnvironmentsGetMultiRolePool_594124(
    name: "appServiceEnvironmentsGetMultiRolePool", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default",
    validator: validate_AppServiceEnvironmentsGetMultiRolePool_594125, base: "",
    url: url_AppServiceEnvironmentsGetMultiRolePool_594126,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsUpdateMultiRolePool_594148 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsUpdateMultiRolePool_594150(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/multiRolePools/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsUpdateMultiRolePool_594149(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a multi-role pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594151 = path.getOrDefault("resourceGroupName")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "resourceGroupName", valid_594151
  var valid_594152 = path.getOrDefault("name")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "name", valid_594152
  var valid_594153 = path.getOrDefault("subscriptionId")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "subscriptionId", valid_594153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594154 = query.getOrDefault("api-version")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "api-version", valid_594154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   multiRolePoolEnvelope: JObject (required)
  ##                        : Properties of the multi-role pool.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594156: Call_AppServiceEnvironmentsUpdateMultiRolePool_594148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a multi-role pool.
  ## 
  let valid = call_594156.validator(path, query, header, formData, body)
  let scheme = call_594156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594156.url(scheme.get, call_594156.host, call_594156.base,
                         call_594156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594156, url, valid)

proc call*(call_594157: Call_AppServiceEnvironmentsUpdateMultiRolePool_594148;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; multiRolePoolEnvelope: JsonNode): Recallable =
  ## appServiceEnvironmentsUpdateMultiRolePool
  ## Create or update a multi-role pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   multiRolePoolEnvelope: JObject (required)
  ##                        : Properties of the multi-role pool.
  var path_594158 = newJObject()
  var query_594159 = newJObject()
  var body_594160 = newJObject()
  add(path_594158, "resourceGroupName", newJString(resourceGroupName))
  add(query_594159, "api-version", newJString(apiVersion))
  add(path_594158, "name", newJString(name))
  add(path_594158, "subscriptionId", newJString(subscriptionId))
  if multiRolePoolEnvelope != nil:
    body_594160 = multiRolePoolEnvelope
  result = call_594157.call(path_594158, query_594159, nil, nil, body_594160)

var appServiceEnvironmentsUpdateMultiRolePool* = Call_AppServiceEnvironmentsUpdateMultiRolePool_594148(
    name: "appServiceEnvironmentsUpdateMultiRolePool", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default",
    validator: validate_AppServiceEnvironmentsUpdateMultiRolePool_594149,
    base: "", url: url_AppServiceEnvironmentsUpdateMultiRolePool_594150,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_594161 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_594163(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"), (kind: ConstantSegment,
        value: "/multiRolePools/default/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/metricdefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_594162(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metric definitions for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: JString (required)
  ##           : Name of the instance in the multi-role pool.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594164 = path.getOrDefault("resourceGroupName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "resourceGroupName", valid_594164
  var valid_594165 = path.getOrDefault("name")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "name", valid_594165
  var valid_594166 = path.getOrDefault("subscriptionId")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "subscriptionId", valid_594166
  var valid_594167 = path.getOrDefault("instance")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "instance", valid_594167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594168 = query.getOrDefault("api-version")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "api-version", valid_594168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594169: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_594161;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  let valid = call_594169.validator(path, query, header, formData, body)
  let scheme = call_594169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594169.url(scheme.get, call_594169.host, call_594169.base,
                         call_594169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594169, url, valid)

proc call*(call_594170: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_594161;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; instance: string): Recallable =
  ## appServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions
  ## Get metric definitions for a specific instance of a multi-role pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: string (required)
  ##           : Name of the instance in the multi-role pool.
  var path_594171 = newJObject()
  var query_594172 = newJObject()
  add(path_594171, "resourceGroupName", newJString(resourceGroupName))
  add(query_594172, "api-version", newJString(apiVersion))
  add(path_594171, "name", newJString(name))
  add(path_594171, "subscriptionId", newJString(subscriptionId))
  add(path_594171, "instance", newJString(instance))
  result = call_594170.call(path_594171, query_594172, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions* = Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_594161(
    name: "appServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/instances/{instance}/metricdefinitions", validator: validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_594162,
    base: "",
    url: url_AppServiceEnvironmentsListMultiRolePoolInstanceMetricDefinitions_594163,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_594173 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_594175(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"), (kind: ConstantSegment,
        value: "/multiRolePools/default/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_594174(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metrics for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: JString (required)
  ##           : Name of the instance in the multi-role pool.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594176 = path.getOrDefault("resourceGroupName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "resourceGroupName", valid_594176
  var valid_594177 = path.getOrDefault("name")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "name", valid_594177
  var valid_594178 = path.getOrDefault("subscriptionId")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "subscriptionId", valid_594178
  var valid_594179 = path.getOrDefault("instance")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "instance", valid_594179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594180 = query.getOrDefault("api-version")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "api-version", valid_594180
  var valid_594181 = query.getOrDefault("details")
  valid_594181 = validateParameter(valid_594181, JBool, required = false, default = nil)
  if valid_594181 != nil:
    section.add "details", valid_594181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594182: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_594173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a specific instance of a multi-role pool of an App Service Environment.
  ## 
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_594173;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; instance: string; details: bool = false): Recallable =
  ## appServiceEnvironmentsListMultiRolePoolInstanceMetrics
  ## Get metrics for a specific instance of a multi-role pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: string (required)
  ##           : Name of the instance in the multi-role pool.
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  add(path_594184, "resourceGroupName", newJString(resourceGroupName))
  add(query_594185, "api-version", newJString(apiVersion))
  add(path_594184, "name", newJString(name))
  add(query_594185, "details", newJBool(details))
  add(path_594184, "subscriptionId", newJString(subscriptionId))
  add(path_594184, "instance", newJString(instance))
  result = call_594183.call(path_594184, query_594185, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePoolInstanceMetrics* = Call_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_594173(
    name: "appServiceEnvironmentsListMultiRolePoolInstanceMetrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/instances/{instance}/metrics",
    validator: validate_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_594174,
    base: "", url: url_AppServiceEnvironmentsListMultiRolePoolInstanceMetrics_594175,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_594186 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListMultiRoleMetricDefinitions_594188(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"), (kind: ConstantSegment,
        value: "/multiRolePools/default/metricdefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMultiRoleMetricDefinitions_594187(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metric definitions for a multi-role pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594189 = path.getOrDefault("resourceGroupName")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "resourceGroupName", valid_594189
  var valid_594190 = path.getOrDefault("name")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "name", valid_594190
  var valid_594191 = path.getOrDefault("subscriptionId")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "subscriptionId", valid_594191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594192 = query.getOrDefault("api-version")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "api-version", valid_594192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594193: Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_594186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a multi-role pool of an App Service Environment.
  ## 
  let valid = call_594193.validator(path, query, header, formData, body)
  let scheme = call_594193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594193.url(scheme.get, call_594193.host, call_594193.base,
                         call_594193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594193, url, valid)

proc call*(call_594194: Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_594186;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListMultiRoleMetricDefinitions
  ## Get metric definitions for a multi-role pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594195 = newJObject()
  var query_594196 = newJObject()
  add(path_594195, "resourceGroupName", newJString(resourceGroupName))
  add(query_594196, "api-version", newJString(apiVersion))
  add(path_594195, "name", newJString(name))
  add(path_594195, "subscriptionId", newJString(subscriptionId))
  result = call_594194.call(path_594195, query_594196, nil, nil, nil)

var appServiceEnvironmentsListMultiRoleMetricDefinitions* = Call_AppServiceEnvironmentsListMultiRoleMetricDefinitions_594186(
    name: "appServiceEnvironmentsListMultiRoleMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/metricdefinitions",
    validator: validate_AppServiceEnvironmentsListMultiRoleMetricDefinitions_594187,
    base: "", url: url_AppServiceEnvironmentsListMultiRoleMetricDefinitions_594188,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRoleMetrics_594197 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListMultiRoleMetrics_594199(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"), (kind: ConstantSegment,
        value: "/multiRolePools/default/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMultiRoleMetrics_594198(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get metrics for a multi-role pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594200 = path.getOrDefault("resourceGroupName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "resourceGroupName", valid_594200
  var valid_594201 = path.getOrDefault("name")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "name", valid_594201
  var valid_594202 = path.getOrDefault("subscriptionId")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "subscriptionId", valid_594202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   endTime: JString
  ##          : End time of the metrics query.
  ##   timeGrain: JString
  ##            : Time granularity of the metrics query.
  ##   startTime: JString
  ##            : Beginning time of the metrics query.
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594203 = query.getOrDefault("api-version")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "api-version", valid_594203
  var valid_594204 = query.getOrDefault("details")
  valid_594204 = validateParameter(valid_594204, JBool, required = false, default = nil)
  if valid_594204 != nil:
    section.add "details", valid_594204
  var valid_594205 = query.getOrDefault("endTime")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "endTime", valid_594205
  var valid_594206 = query.getOrDefault("timeGrain")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "timeGrain", valid_594206
  var valid_594207 = query.getOrDefault("startTime")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "startTime", valid_594207
  var valid_594208 = query.getOrDefault("$filter")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "$filter", valid_594208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594209: Call_AppServiceEnvironmentsListMultiRoleMetrics_594197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a multi-role pool of an App Service Environment.
  ## 
  let valid = call_594209.validator(path, query, header, formData, body)
  let scheme = call_594209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594209.url(scheme.get, call_594209.host, call_594209.base,
                         call_594209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594209, url, valid)

proc call*(call_594210: Call_AppServiceEnvironmentsListMultiRoleMetrics_594197;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; details: bool = false; endTime: string = "";
          timeGrain: string = ""; startTime: string = ""; Filter: string = ""): Recallable =
  ## appServiceEnvironmentsListMultiRoleMetrics
  ## Get metrics for a multi-role pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   endTime: string
  ##          : End time of the metrics query.
  ##   timeGrain: string
  ##            : Time granularity of the metrics query.
  ##   startTime: string
  ##            : Beginning time of the metrics query.
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_594211 = newJObject()
  var query_594212 = newJObject()
  add(path_594211, "resourceGroupName", newJString(resourceGroupName))
  add(query_594212, "api-version", newJString(apiVersion))
  add(path_594211, "name", newJString(name))
  add(query_594212, "details", newJBool(details))
  add(path_594211, "subscriptionId", newJString(subscriptionId))
  add(query_594212, "endTime", newJString(endTime))
  add(query_594212, "timeGrain", newJString(timeGrain))
  add(query_594212, "startTime", newJString(startTime))
  add(query_594212, "$filter", newJString(Filter))
  result = call_594210.call(path_594211, query_594212, nil, nil, nil)

var appServiceEnvironmentsListMultiRoleMetrics* = Call_AppServiceEnvironmentsListMultiRoleMetrics_594197(
    name: "appServiceEnvironmentsListMultiRoleMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/metrics",
    validator: validate_AppServiceEnvironmentsListMultiRoleMetrics_594198,
    base: "", url: url_AppServiceEnvironmentsListMultiRoleMetrics_594199,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRolePoolSkus_594213 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListMultiRolePoolSkus_594215(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/multiRolePools/default/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMultiRolePoolSkus_594214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get available SKUs for scaling a multi-role pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594216 = path.getOrDefault("resourceGroupName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "resourceGroupName", valid_594216
  var valid_594217 = path.getOrDefault("name")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "name", valid_594217
  var valid_594218 = path.getOrDefault("subscriptionId")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "subscriptionId", valid_594218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594219 = query.getOrDefault("api-version")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "api-version", valid_594219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594220: Call_AppServiceEnvironmentsListMultiRolePoolSkus_594213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get available SKUs for scaling a multi-role pool.
  ## 
  let valid = call_594220.validator(path, query, header, formData, body)
  let scheme = call_594220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594220.url(scheme.get, call_594220.host, call_594220.base,
                         call_594220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594220, url, valid)

proc call*(call_594221: Call_AppServiceEnvironmentsListMultiRolePoolSkus_594213;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListMultiRolePoolSkus
  ## Get available SKUs for scaling a multi-role pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594222 = newJObject()
  var query_594223 = newJObject()
  add(path_594222, "resourceGroupName", newJString(resourceGroupName))
  add(query_594223, "api-version", newJString(apiVersion))
  add(path_594222, "name", newJString(name))
  add(path_594222, "subscriptionId", newJString(subscriptionId))
  result = call_594221.call(path_594222, query_594223, nil, nil, nil)

var appServiceEnvironmentsListMultiRolePoolSkus* = Call_AppServiceEnvironmentsListMultiRolePoolSkus_594213(
    name: "appServiceEnvironmentsListMultiRolePoolSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/skus",
    validator: validate_AppServiceEnvironmentsListMultiRolePoolSkus_594214,
    base: "", url: url_AppServiceEnvironmentsListMultiRolePoolSkus_594215,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListMultiRoleUsages_594224 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListMultiRoleUsages_594226(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/multiRolePools/default/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListMultiRoleUsages_594225(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get usage metrics for a multi-role pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594227 = path.getOrDefault("resourceGroupName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "resourceGroupName", valid_594227
  var valid_594228 = path.getOrDefault("name")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "name", valid_594228
  var valid_594229 = path.getOrDefault("subscriptionId")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "subscriptionId", valid_594229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594230 = query.getOrDefault("api-version")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "api-version", valid_594230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594231: Call_AppServiceEnvironmentsListMultiRoleUsages_594224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get usage metrics for a multi-role pool of an App Service Environment.
  ## 
  let valid = call_594231.validator(path, query, header, formData, body)
  let scheme = call_594231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594231.url(scheme.get, call_594231.host, call_594231.base,
                         call_594231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594231, url, valid)

proc call*(call_594232: Call_AppServiceEnvironmentsListMultiRoleUsages_594224;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListMultiRoleUsages
  ## Get usage metrics for a multi-role pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594233 = newJObject()
  var query_594234 = newJObject()
  add(path_594233, "resourceGroupName", newJString(resourceGroupName))
  add(query_594234, "api-version", newJString(apiVersion))
  add(path_594233, "name", newJString(name))
  add(path_594233, "subscriptionId", newJString(subscriptionId))
  result = call_594232.call(path_594233, query_594234, nil, nil, nil)

var appServiceEnvironmentsListMultiRoleUsages* = Call_AppServiceEnvironmentsListMultiRoleUsages_594224(
    name: "appServiceEnvironmentsListMultiRoleUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/multiRolePools/default/usages",
    validator: validate_AppServiceEnvironmentsListMultiRoleUsages_594225,
    base: "", url: url_AppServiceEnvironmentsListMultiRoleUsages_594226,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListOperations_594235 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListOperations_594237(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListOperations_594236(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all currently running operations on the App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594238 = path.getOrDefault("resourceGroupName")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "resourceGroupName", valid_594238
  var valid_594239 = path.getOrDefault("name")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "name", valid_594239
  var valid_594240 = path.getOrDefault("subscriptionId")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "subscriptionId", valid_594240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594241 = query.getOrDefault("api-version")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "api-version", valid_594241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594242: Call_AppServiceEnvironmentsListOperations_594235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all currently running operations on the App Service Environment.
  ## 
  let valid = call_594242.validator(path, query, header, formData, body)
  let scheme = call_594242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594242.url(scheme.get, call_594242.host, call_594242.base,
                         call_594242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594242, url, valid)

proc call*(call_594243: Call_AppServiceEnvironmentsListOperations_594235;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListOperations
  ## List all currently running operations on the App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594244 = newJObject()
  var query_594245 = newJObject()
  add(path_594244, "resourceGroupName", newJString(resourceGroupName))
  add(query_594245, "api-version", newJString(apiVersion))
  add(path_594244, "name", newJString(name))
  add(path_594244, "subscriptionId", newJString(subscriptionId))
  result = call_594243.call(path_594244, query_594245, nil, nil, nil)

var appServiceEnvironmentsListOperations* = Call_AppServiceEnvironmentsListOperations_594235(
    name: "appServiceEnvironmentsListOperations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/operations",
    validator: validate_AppServiceEnvironmentsListOperations_594236, base: "",
    url: url_AppServiceEnvironmentsListOperations_594237, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_594246 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_594248(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"), (kind: ConstantSegment,
        value: "/outboundNetworkDependenciesEndpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_594247(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the network endpoints of all outbound dependencies of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594249 = path.getOrDefault("resourceGroupName")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "resourceGroupName", valid_594249
  var valid_594250 = path.getOrDefault("name")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "name", valid_594250
  var valid_594251 = path.getOrDefault("subscriptionId")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "subscriptionId", valid_594251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594252 = query.getOrDefault("api-version")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "api-version", valid_594252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594253: Call_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_594246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the network endpoints of all outbound dependencies of an App Service Environment.
  ## 
  let valid = call_594253.validator(path, query, header, formData, body)
  let scheme = call_594253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594253.url(scheme.get, call_594253.host, call_594253.base,
                         call_594253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594253, url, valid)

proc call*(call_594254: Call_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_594246;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints
  ## Get the network endpoints of all outbound dependencies of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594255 = newJObject()
  var query_594256 = newJObject()
  add(path_594255, "resourceGroupName", newJString(resourceGroupName))
  add(query_594256, "api-version", newJString(apiVersion))
  add(path_594255, "name", newJString(name))
  add(path_594255, "subscriptionId", newJString(subscriptionId))
  result = call_594254.call(path_594255, query_594256, nil, nil, nil)

var appServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints* = Call_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_594246(
    name: "appServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/outboundNetworkDependenciesEndpoints", validator: validate_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_594247,
    base: "",
    url: url_AppServiceEnvironmentsGetOutboundNetworkDependenciesEndpoints_594248,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsReboot_594257 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsReboot_594259(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/reboot")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsReboot_594258(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reboot all machines in an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594260 = path.getOrDefault("resourceGroupName")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "resourceGroupName", valid_594260
  var valid_594261 = path.getOrDefault("name")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "name", valid_594261
  var valid_594262 = path.getOrDefault("subscriptionId")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "subscriptionId", valid_594262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594263 = query.getOrDefault("api-version")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "api-version", valid_594263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594264: Call_AppServiceEnvironmentsReboot_594257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reboot all machines in an App Service Environment.
  ## 
  let valid = call_594264.validator(path, query, header, formData, body)
  let scheme = call_594264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594264.url(scheme.get, call_594264.host, call_594264.base,
                         call_594264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594264, url, valid)

proc call*(call_594265: Call_AppServiceEnvironmentsReboot_594257;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsReboot
  ## Reboot all machines in an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594266 = newJObject()
  var query_594267 = newJObject()
  add(path_594266, "resourceGroupName", newJString(resourceGroupName))
  add(query_594267, "api-version", newJString(apiVersion))
  add(path_594266, "name", newJString(name))
  add(path_594266, "subscriptionId", newJString(subscriptionId))
  result = call_594265.call(path_594266, query_594267, nil, nil, nil)

var appServiceEnvironmentsReboot* = Call_AppServiceEnvironmentsReboot_594257(
    name: "appServiceEnvironmentsReboot", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/reboot",
    validator: validate_AppServiceEnvironmentsReboot_594258, base: "",
    url: url_AppServiceEnvironmentsReboot_594259, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsResume_594268 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsResume_594270(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsResume_594269(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resume an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594271 = path.getOrDefault("resourceGroupName")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "resourceGroupName", valid_594271
  var valid_594272 = path.getOrDefault("name")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "name", valid_594272
  var valid_594273 = path.getOrDefault("subscriptionId")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "subscriptionId", valid_594273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594274 = query.getOrDefault("api-version")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "api-version", valid_594274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594275: Call_AppServiceEnvironmentsResume_594268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume an App Service Environment.
  ## 
  let valid = call_594275.validator(path, query, header, formData, body)
  let scheme = call_594275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594275.url(scheme.get, call_594275.host, call_594275.base,
                         call_594275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594275, url, valid)

proc call*(call_594276: Call_AppServiceEnvironmentsResume_594268;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsResume
  ## Resume an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594277 = newJObject()
  var query_594278 = newJObject()
  add(path_594277, "resourceGroupName", newJString(resourceGroupName))
  add(query_594278, "api-version", newJString(apiVersion))
  add(path_594277, "name", newJString(name))
  add(path_594277, "subscriptionId", newJString(subscriptionId))
  result = call_594276.call(path_594277, query_594278, nil, nil, nil)

var appServiceEnvironmentsResume* = Call_AppServiceEnvironmentsResume_594268(
    name: "appServiceEnvironmentsResume", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/resume",
    validator: validate_AppServiceEnvironmentsResume_594269, base: "",
    url: url_AppServiceEnvironmentsResume_594270, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListAppServicePlans_594279 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListAppServicePlans_594281(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/serverfarms")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListAppServicePlans_594280(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all App Service plans in an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594282 = path.getOrDefault("resourceGroupName")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "resourceGroupName", valid_594282
  var valid_594283 = path.getOrDefault("name")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "name", valid_594283
  var valid_594284 = path.getOrDefault("subscriptionId")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "subscriptionId", valid_594284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594285 = query.getOrDefault("api-version")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "api-version", valid_594285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594286: Call_AppServiceEnvironmentsListAppServicePlans_594279;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all App Service plans in an App Service Environment.
  ## 
  let valid = call_594286.validator(path, query, header, formData, body)
  let scheme = call_594286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594286.url(scheme.get, call_594286.host, call_594286.base,
                         call_594286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594286, url, valid)

proc call*(call_594287: Call_AppServiceEnvironmentsListAppServicePlans_594279;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListAppServicePlans
  ## Get all App Service plans in an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594288 = newJObject()
  var query_594289 = newJObject()
  add(path_594288, "resourceGroupName", newJString(resourceGroupName))
  add(query_594289, "api-version", newJString(apiVersion))
  add(path_594288, "name", newJString(name))
  add(path_594288, "subscriptionId", newJString(subscriptionId))
  result = call_594287.call(path_594288, query_594289, nil, nil, nil)

var appServiceEnvironmentsListAppServicePlans* = Call_AppServiceEnvironmentsListAppServicePlans_594279(
    name: "appServiceEnvironmentsListAppServicePlans", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/serverfarms",
    validator: validate_AppServiceEnvironmentsListAppServicePlans_594280,
    base: "", url: url_AppServiceEnvironmentsListAppServicePlans_594281,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebApps_594290 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListWebApps_594292(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/sites")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWebApps_594291(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all apps in an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594293 = path.getOrDefault("resourceGroupName")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "resourceGroupName", valid_594293
  var valid_594294 = path.getOrDefault("name")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "name", valid_594294
  var valid_594295 = path.getOrDefault("subscriptionId")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "subscriptionId", valid_594295
  result.add "path", section
  ## parameters in `query` object:
  ##   propertiesToInclude: JString
  ##                      : Comma separated list of app properties to include.
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  var valid_594296 = query.getOrDefault("propertiesToInclude")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "propertiesToInclude", valid_594296
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594297 = query.getOrDefault("api-version")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "api-version", valid_594297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594298: Call_AppServiceEnvironmentsListWebApps_594290;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all apps in an App Service Environment.
  ## 
  let valid = call_594298.validator(path, query, header, formData, body)
  let scheme = call_594298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594298.url(scheme.get, call_594298.host, call_594298.base,
                         call_594298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594298, url, valid)

proc call*(call_594299: Call_AppServiceEnvironmentsListWebApps_594290;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; propertiesToInclude: string = ""): Recallable =
  ## appServiceEnvironmentsListWebApps
  ## Get all apps in an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   propertiesToInclude: string
  ##                      : Comma separated list of app properties to include.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594300 = newJObject()
  var query_594301 = newJObject()
  add(path_594300, "resourceGroupName", newJString(resourceGroupName))
  add(query_594301, "propertiesToInclude", newJString(propertiesToInclude))
  add(query_594301, "api-version", newJString(apiVersion))
  add(path_594300, "name", newJString(name))
  add(path_594300, "subscriptionId", newJString(subscriptionId))
  result = call_594299.call(path_594300, query_594301, nil, nil, nil)

var appServiceEnvironmentsListWebApps* = Call_AppServiceEnvironmentsListWebApps_594290(
    name: "appServiceEnvironmentsListWebApps", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/sites",
    validator: validate_AppServiceEnvironmentsListWebApps_594291, base: "",
    url: url_AppServiceEnvironmentsListWebApps_594292, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsSuspend_594302 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsSuspend_594304(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/suspend")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsSuspend_594303(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Suspend an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594305 = path.getOrDefault("resourceGroupName")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "resourceGroupName", valid_594305
  var valid_594306 = path.getOrDefault("name")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "name", valid_594306
  var valid_594307 = path.getOrDefault("subscriptionId")
  valid_594307 = validateParameter(valid_594307, JString, required = true,
                                 default = nil)
  if valid_594307 != nil:
    section.add "subscriptionId", valid_594307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594308 = query.getOrDefault("api-version")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "api-version", valid_594308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594309: Call_AppServiceEnvironmentsSuspend_594302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspend an App Service Environment.
  ## 
  let valid = call_594309.validator(path, query, header, formData, body)
  let scheme = call_594309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594309.url(scheme.get, call_594309.host, call_594309.base,
                         call_594309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594309, url, valid)

proc call*(call_594310: Call_AppServiceEnvironmentsSuspend_594302;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsSuspend
  ## Suspend an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594311 = newJObject()
  var query_594312 = newJObject()
  add(path_594311, "resourceGroupName", newJString(resourceGroupName))
  add(query_594312, "api-version", newJString(apiVersion))
  add(path_594311, "name", newJString(name))
  add(path_594311, "subscriptionId", newJString(subscriptionId))
  result = call_594310.call(path_594311, query_594312, nil, nil, nil)

var appServiceEnvironmentsSuspend* = Call_AppServiceEnvironmentsSuspend_594302(
    name: "appServiceEnvironmentsSuspend", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/suspend",
    validator: validate_AppServiceEnvironmentsSuspend_594303, base: "",
    url: url_AppServiceEnvironmentsSuspend_594304, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListUsages_594313 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListUsages_594315(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListUsages_594314(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get global usage metrics of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594316 = path.getOrDefault("resourceGroupName")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "resourceGroupName", valid_594316
  var valid_594317 = path.getOrDefault("name")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "name", valid_594317
  var valid_594318 = path.getOrDefault("subscriptionId")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "subscriptionId", valid_594318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594319 = query.getOrDefault("api-version")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "api-version", valid_594319
  var valid_594320 = query.getOrDefault("$filter")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "$filter", valid_594320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594321: Call_AppServiceEnvironmentsListUsages_594313;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get global usage metrics of an App Service Environment.
  ## 
  let valid = call_594321.validator(path, query, header, formData, body)
  let scheme = call_594321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594321.url(scheme.get, call_594321.host, call_594321.base,
                         call_594321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594321, url, valid)

proc call*(call_594322: Call_AppServiceEnvironmentsListUsages_594313;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## appServiceEnvironmentsListUsages
  ## Get global usage metrics of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_594323 = newJObject()
  var query_594324 = newJObject()
  add(path_594323, "resourceGroupName", newJString(resourceGroupName))
  add(query_594324, "api-version", newJString(apiVersion))
  add(path_594323, "name", newJString(name))
  add(path_594323, "subscriptionId", newJString(subscriptionId))
  add(query_594324, "$filter", newJString(Filter))
  result = call_594322.call(path_594323, query_594324, nil, nil, nil)

var appServiceEnvironmentsListUsages* = Call_AppServiceEnvironmentsListUsages_594313(
    name: "appServiceEnvironmentsListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/usages",
    validator: validate_AppServiceEnvironmentsListUsages_594314, base: "",
    url: url_AppServiceEnvironmentsListUsages_594315, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPools_594325 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListWorkerPools_594327(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWorkerPools_594326(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all worker pools of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594328 = path.getOrDefault("resourceGroupName")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "resourceGroupName", valid_594328
  var valid_594329 = path.getOrDefault("name")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "name", valid_594329
  var valid_594330 = path.getOrDefault("subscriptionId")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "subscriptionId", valid_594330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594331 = query.getOrDefault("api-version")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "api-version", valid_594331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594332: Call_AppServiceEnvironmentsListWorkerPools_594325;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all worker pools of an App Service Environment.
  ## 
  let valid = call_594332.validator(path, query, header, formData, body)
  let scheme = call_594332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594332.url(scheme.get, call_594332.host, call_594332.base,
                         call_594332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594332, url, valid)

proc call*(call_594333: Call_AppServiceEnvironmentsListWorkerPools_594325;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListWorkerPools
  ## Get all worker pools of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594334 = newJObject()
  var query_594335 = newJObject()
  add(path_594334, "resourceGroupName", newJString(resourceGroupName))
  add(query_594335, "api-version", newJString(apiVersion))
  add(path_594334, "name", newJString(name))
  add(path_594334, "subscriptionId", newJString(subscriptionId))
  result = call_594333.call(path_594334, query_594335, nil, nil, nil)

var appServiceEnvironmentsListWorkerPools* = Call_AppServiceEnvironmentsListWorkerPools_594325(
    name: "appServiceEnvironmentsListWorkerPools", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools",
    validator: validate_AppServiceEnvironmentsListWorkerPools_594326, base: "",
    url: url_AppServiceEnvironmentsListWorkerPools_594327, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_594348 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsCreateOrUpdateWorkerPool_594350(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsCreateOrUpdateWorkerPool_594349(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update a worker pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594351 = path.getOrDefault("resourceGroupName")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "resourceGroupName", valid_594351
  var valid_594352 = path.getOrDefault("name")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "name", valid_594352
  var valid_594353 = path.getOrDefault("workerPoolName")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "workerPoolName", valid_594353
  var valid_594354 = path.getOrDefault("subscriptionId")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = nil)
  if valid_594354 != nil:
    section.add "subscriptionId", valid_594354
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594355 = query.getOrDefault("api-version")
  valid_594355 = validateParameter(valid_594355, JString, required = true,
                                 default = nil)
  if valid_594355 != nil:
    section.add "api-version", valid_594355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   workerPoolEnvelope: JObject (required)
  ##                     : Properties of the worker pool.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594357: Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_594348;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a worker pool.
  ## 
  let valid = call_594357.validator(path, query, header, formData, body)
  let scheme = call_594357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594357.url(scheme.get, call_594357.host, call_594357.base,
                         call_594357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594357, url, valid)

proc call*(call_594358: Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_594348;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string;
          workerPoolEnvelope: JsonNode): Recallable =
  ## appServiceEnvironmentsCreateOrUpdateWorkerPool
  ## Create or update a worker pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   workerPoolEnvelope: JObject (required)
  ##                     : Properties of the worker pool.
  var path_594359 = newJObject()
  var query_594360 = newJObject()
  var body_594361 = newJObject()
  add(path_594359, "resourceGroupName", newJString(resourceGroupName))
  add(query_594360, "api-version", newJString(apiVersion))
  add(path_594359, "name", newJString(name))
  add(path_594359, "workerPoolName", newJString(workerPoolName))
  add(path_594359, "subscriptionId", newJString(subscriptionId))
  if workerPoolEnvelope != nil:
    body_594361 = workerPoolEnvelope
  result = call_594358.call(path_594359, query_594360, nil, nil, body_594361)

var appServiceEnvironmentsCreateOrUpdateWorkerPool* = Call_AppServiceEnvironmentsCreateOrUpdateWorkerPool_594348(
    name: "appServiceEnvironmentsCreateOrUpdateWorkerPool",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}",
    validator: validate_AppServiceEnvironmentsCreateOrUpdateWorkerPool_594349,
    base: "", url: url_AppServiceEnvironmentsCreateOrUpdateWorkerPool_594350,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsGetWorkerPool_594336 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsGetWorkerPool_594338(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsGetWorkerPool_594337(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get properties of a worker pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594339 = path.getOrDefault("resourceGroupName")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "resourceGroupName", valid_594339
  var valid_594340 = path.getOrDefault("name")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "name", valid_594340
  var valid_594341 = path.getOrDefault("workerPoolName")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "workerPoolName", valid_594341
  var valid_594342 = path.getOrDefault("subscriptionId")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "subscriptionId", valid_594342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594343 = query.getOrDefault("api-version")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "api-version", valid_594343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594344: Call_AppServiceEnvironmentsGetWorkerPool_594336;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get properties of a worker pool.
  ## 
  let valid = call_594344.validator(path, query, header, formData, body)
  let scheme = call_594344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594344.url(scheme.get, call_594344.host, call_594344.base,
                         call_594344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594344, url, valid)

proc call*(call_594345: Call_AppServiceEnvironmentsGetWorkerPool_594336;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsGetWorkerPool
  ## Get properties of a worker pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594346 = newJObject()
  var query_594347 = newJObject()
  add(path_594346, "resourceGroupName", newJString(resourceGroupName))
  add(query_594347, "api-version", newJString(apiVersion))
  add(path_594346, "name", newJString(name))
  add(path_594346, "workerPoolName", newJString(workerPoolName))
  add(path_594346, "subscriptionId", newJString(subscriptionId))
  result = call_594345.call(path_594346, query_594347, nil, nil, nil)

var appServiceEnvironmentsGetWorkerPool* = Call_AppServiceEnvironmentsGetWorkerPool_594336(
    name: "appServiceEnvironmentsGetWorkerPool", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}",
    validator: validate_AppServiceEnvironmentsGetWorkerPool_594337, base: "",
    url: url_AppServiceEnvironmentsGetWorkerPool_594338, schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsUpdateWorkerPool_594362 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsUpdateWorkerPool_594364(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsUpdateWorkerPool_594363(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a worker pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594365 = path.getOrDefault("resourceGroupName")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "resourceGroupName", valid_594365
  var valid_594366 = path.getOrDefault("name")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = nil)
  if valid_594366 != nil:
    section.add "name", valid_594366
  var valid_594367 = path.getOrDefault("workerPoolName")
  valid_594367 = validateParameter(valid_594367, JString, required = true,
                                 default = nil)
  if valid_594367 != nil:
    section.add "workerPoolName", valid_594367
  var valid_594368 = path.getOrDefault("subscriptionId")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "subscriptionId", valid_594368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594369 = query.getOrDefault("api-version")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "api-version", valid_594369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   workerPoolEnvelope: JObject (required)
  ##                     : Properties of the worker pool.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594371: Call_AppServiceEnvironmentsUpdateWorkerPool_594362;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a worker pool.
  ## 
  let valid = call_594371.validator(path, query, header, formData, body)
  let scheme = call_594371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594371.url(scheme.get, call_594371.host, call_594371.base,
                         call_594371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594371, url, valid)

proc call*(call_594372: Call_AppServiceEnvironmentsUpdateWorkerPool_594362;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string;
          workerPoolEnvelope: JsonNode): Recallable =
  ## appServiceEnvironmentsUpdateWorkerPool
  ## Create or update a worker pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   workerPoolEnvelope: JObject (required)
  ##                     : Properties of the worker pool.
  var path_594373 = newJObject()
  var query_594374 = newJObject()
  var body_594375 = newJObject()
  add(path_594373, "resourceGroupName", newJString(resourceGroupName))
  add(query_594374, "api-version", newJString(apiVersion))
  add(path_594373, "name", newJString(name))
  add(path_594373, "workerPoolName", newJString(workerPoolName))
  add(path_594373, "subscriptionId", newJString(subscriptionId))
  if workerPoolEnvelope != nil:
    body_594375 = workerPoolEnvelope
  result = call_594372.call(path_594373, query_594374, nil, nil, body_594375)

var appServiceEnvironmentsUpdateWorkerPool* = Call_AppServiceEnvironmentsUpdateWorkerPool_594362(
    name: "appServiceEnvironmentsUpdateWorkerPool", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}",
    validator: validate_AppServiceEnvironmentsUpdateWorkerPool_594363, base: "",
    url: url_AppServiceEnvironmentsUpdateWorkerPool_594364,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_594376 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_594378(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/metricdefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_594377(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metric definitions for a specific instance of a worker pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: JString (required)
  ##           : Name of the instance in the worker pool.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594379 = path.getOrDefault("resourceGroupName")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "resourceGroupName", valid_594379
  var valid_594380 = path.getOrDefault("name")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "name", valid_594380
  var valid_594381 = path.getOrDefault("workerPoolName")
  valid_594381 = validateParameter(valid_594381, JString, required = true,
                                 default = nil)
  if valid_594381 != nil:
    section.add "workerPoolName", valid_594381
  var valid_594382 = path.getOrDefault("subscriptionId")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "subscriptionId", valid_594382
  var valid_594383 = path.getOrDefault("instance")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "instance", valid_594383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594384 = query.getOrDefault("api-version")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = nil)
  if valid_594384 != nil:
    section.add "api-version", valid_594384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594385: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_594376;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a specific instance of a worker pool of an App Service Environment.
  ## 
  let valid = call_594385.validator(path, query, header, formData, body)
  let scheme = call_594385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594385.url(scheme.get, call_594385.host, call_594385.base,
                         call_594385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594385, url, valid)

proc call*(call_594386: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_594376;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string; instance: string): Recallable =
  ## appServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions
  ## Get metric definitions for a specific instance of a worker pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: string (required)
  ##           : Name of the instance in the worker pool.
  var path_594387 = newJObject()
  var query_594388 = newJObject()
  add(path_594387, "resourceGroupName", newJString(resourceGroupName))
  add(query_594388, "api-version", newJString(apiVersion))
  add(path_594387, "name", newJString(name))
  add(path_594387, "workerPoolName", newJString(workerPoolName))
  add(path_594387, "subscriptionId", newJString(subscriptionId))
  add(path_594387, "instance", newJString(instance))
  result = call_594386.call(path_594387, query_594388, nil, nil, nil)

var appServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions* = Call_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_594376(
    name: "appServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/instances/{instance}/metricdefinitions", validator: validate_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_594377,
    base: "",
    url: url_AppServiceEnvironmentsListWorkerPoolInstanceMetricDefinitions_594378,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_594389 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_594391(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_594390(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metrics for a specific instance of a worker pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: JString (required)
  ##           : Name of the instance in the worker pool.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594392 = path.getOrDefault("resourceGroupName")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "resourceGroupName", valid_594392
  var valid_594393 = path.getOrDefault("name")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "name", valid_594393
  var valid_594394 = path.getOrDefault("workerPoolName")
  valid_594394 = validateParameter(valid_594394, JString, required = true,
                                 default = nil)
  if valid_594394 != nil:
    section.add "workerPoolName", valid_594394
  var valid_594395 = path.getOrDefault("subscriptionId")
  valid_594395 = validateParameter(valid_594395, JString, required = true,
                                 default = nil)
  if valid_594395 != nil:
    section.add "subscriptionId", valid_594395
  var valid_594396 = path.getOrDefault("instance")
  valid_594396 = validateParameter(valid_594396, JString, required = true,
                                 default = nil)
  if valid_594396 != nil:
    section.add "instance", valid_594396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594397 = query.getOrDefault("api-version")
  valid_594397 = validateParameter(valid_594397, JString, required = true,
                                 default = nil)
  if valid_594397 != nil:
    section.add "api-version", valid_594397
  var valid_594398 = query.getOrDefault("details")
  valid_594398 = validateParameter(valid_594398, JBool, required = false, default = nil)
  if valid_594398 != nil:
    section.add "details", valid_594398
  var valid_594399 = query.getOrDefault("$filter")
  valid_594399 = validateParameter(valid_594399, JString, required = false,
                                 default = nil)
  if valid_594399 != nil:
    section.add "$filter", valid_594399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594400: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_594389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a specific instance of a worker pool of an App Service Environment.
  ## 
  let valid = call_594400.validator(path, query, header, formData, body)
  let scheme = call_594400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594400.url(scheme.get, call_594400.host, call_594400.base,
                         call_594400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594400, url, valid)

proc call*(call_594401: Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_594389;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string; instance: string;
          details: bool = false; Filter: string = ""): Recallable =
  ## appServiceEnvironmentsListWorkerPoolInstanceMetrics
  ## Get metrics for a specific instance of a worker pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   instance: string (required)
  ##           : Name of the instance in the worker pool.
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_594402 = newJObject()
  var query_594403 = newJObject()
  add(path_594402, "resourceGroupName", newJString(resourceGroupName))
  add(query_594403, "api-version", newJString(apiVersion))
  add(path_594402, "name", newJString(name))
  add(query_594403, "details", newJBool(details))
  add(path_594402, "workerPoolName", newJString(workerPoolName))
  add(path_594402, "subscriptionId", newJString(subscriptionId))
  add(path_594402, "instance", newJString(instance))
  add(query_594403, "$filter", newJString(Filter))
  result = call_594401.call(path_594402, query_594403, nil, nil, nil)

var appServiceEnvironmentsListWorkerPoolInstanceMetrics* = Call_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_594389(
    name: "appServiceEnvironmentsListWorkerPoolInstanceMetrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/instances/{instance}/metrics",
    validator: validate_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_594390,
    base: "", url: url_AppServiceEnvironmentsListWorkerPoolInstanceMetrics_594391,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_594404 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListWebWorkerMetricDefinitions_594406(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName"),
               (kind: ConstantSegment, value: "/metricdefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWebWorkerMetricDefinitions_594405(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get metric definitions for a worker pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594407 = path.getOrDefault("resourceGroupName")
  valid_594407 = validateParameter(valid_594407, JString, required = true,
                                 default = nil)
  if valid_594407 != nil:
    section.add "resourceGroupName", valid_594407
  var valid_594408 = path.getOrDefault("name")
  valid_594408 = validateParameter(valid_594408, JString, required = true,
                                 default = nil)
  if valid_594408 != nil:
    section.add "name", valid_594408
  var valid_594409 = path.getOrDefault("workerPoolName")
  valid_594409 = validateParameter(valid_594409, JString, required = true,
                                 default = nil)
  if valid_594409 != nil:
    section.add "workerPoolName", valid_594409
  var valid_594410 = path.getOrDefault("subscriptionId")
  valid_594410 = validateParameter(valid_594410, JString, required = true,
                                 default = nil)
  if valid_594410 != nil:
    section.add "subscriptionId", valid_594410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594411 = query.getOrDefault("api-version")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "api-version", valid_594411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594412: Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_594404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metric definitions for a worker pool of an App Service Environment.
  ## 
  let valid = call_594412.validator(path, query, header, formData, body)
  let scheme = call_594412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594412.url(scheme.get, call_594412.host, call_594412.base,
                         call_594412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594412, url, valid)

proc call*(call_594413: Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_594404;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListWebWorkerMetricDefinitions
  ## Get metric definitions for a worker pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594414 = newJObject()
  var query_594415 = newJObject()
  add(path_594414, "resourceGroupName", newJString(resourceGroupName))
  add(query_594415, "api-version", newJString(apiVersion))
  add(path_594414, "name", newJString(name))
  add(path_594414, "workerPoolName", newJString(workerPoolName))
  add(path_594414, "subscriptionId", newJString(subscriptionId))
  result = call_594413.call(path_594414, query_594415, nil, nil, nil)

var appServiceEnvironmentsListWebWorkerMetricDefinitions* = Call_AppServiceEnvironmentsListWebWorkerMetricDefinitions_594404(
    name: "appServiceEnvironmentsListWebWorkerMetricDefinitions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/metricdefinitions",
    validator: validate_AppServiceEnvironmentsListWebWorkerMetricDefinitions_594405,
    base: "", url: url_AppServiceEnvironmentsListWebWorkerMetricDefinitions_594406,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebWorkerMetrics_594416 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListWebWorkerMetrics_594418(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWebWorkerMetrics_594417(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get metrics for a worker pool of a AppServiceEnvironment (App Service Environment).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of worker pool
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594419 = path.getOrDefault("resourceGroupName")
  valid_594419 = validateParameter(valid_594419, JString, required = true,
                                 default = nil)
  if valid_594419 != nil:
    section.add "resourceGroupName", valid_594419
  var valid_594420 = path.getOrDefault("name")
  valid_594420 = validateParameter(valid_594420, JString, required = true,
                                 default = nil)
  if valid_594420 != nil:
    section.add "name", valid_594420
  var valid_594421 = path.getOrDefault("workerPoolName")
  valid_594421 = validateParameter(valid_594421, JString, required = true,
                                 default = nil)
  if valid_594421 != nil:
    section.add "workerPoolName", valid_594421
  var valid_594422 = path.getOrDefault("subscriptionId")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "subscriptionId", valid_594422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   details: JBool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   $filter: JString
  ##          : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594423 = query.getOrDefault("api-version")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "api-version", valid_594423
  var valid_594424 = query.getOrDefault("details")
  valid_594424 = validateParameter(valid_594424, JBool, required = false, default = nil)
  if valid_594424 != nil:
    section.add "details", valid_594424
  var valid_594425 = query.getOrDefault("$filter")
  valid_594425 = validateParameter(valid_594425, JString, required = false,
                                 default = nil)
  if valid_594425 != nil:
    section.add "$filter", valid_594425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594426: Call_AppServiceEnvironmentsListWebWorkerMetrics_594416;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get metrics for a worker pool of a AppServiceEnvironment (App Service Environment).
  ## 
  let valid = call_594426.validator(path, query, header, formData, body)
  let scheme = call_594426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594426.url(scheme.get, call_594426.host, call_594426.base,
                         call_594426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594426, url, valid)

proc call*(call_594427: Call_AppServiceEnvironmentsListWebWorkerMetrics_594416;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string; details: bool = false;
          Filter: string = ""): Recallable =
  ## appServiceEnvironmentsListWebWorkerMetrics
  ## Get metrics for a worker pool of a AppServiceEnvironment (App Service Environment).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   details: bool
  ##          : Specify <code>true</code> to include instance details. The default is <code>false</code>.
  ##   workerPoolName: string (required)
  ##                 : Name of worker pool
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   Filter: string
  ##         : Return only usages/metrics specified in the filter. Filter conforms to odata syntax. Example: $filter=(name.value eq 'Metric1' or name.value eq 'Metric2') and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[Hour|Minute|Day]'.
  var path_594428 = newJObject()
  var query_594429 = newJObject()
  add(path_594428, "resourceGroupName", newJString(resourceGroupName))
  add(query_594429, "api-version", newJString(apiVersion))
  add(path_594428, "name", newJString(name))
  add(query_594429, "details", newJBool(details))
  add(path_594428, "workerPoolName", newJString(workerPoolName))
  add(path_594428, "subscriptionId", newJString(subscriptionId))
  add(query_594429, "$filter", newJString(Filter))
  result = call_594427.call(path_594428, query_594429, nil, nil, nil)

var appServiceEnvironmentsListWebWorkerMetrics* = Call_AppServiceEnvironmentsListWebWorkerMetrics_594416(
    name: "appServiceEnvironmentsListWebWorkerMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/metrics",
    validator: validate_AppServiceEnvironmentsListWebWorkerMetrics_594417,
    base: "", url: url_AppServiceEnvironmentsListWebWorkerMetrics_594418,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWorkerPoolSkus_594430 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListWorkerPoolSkus_594432(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWorkerPoolSkus_594431(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get available SKUs for scaling a worker pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594433 = path.getOrDefault("resourceGroupName")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "resourceGroupName", valid_594433
  var valid_594434 = path.getOrDefault("name")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "name", valid_594434
  var valid_594435 = path.getOrDefault("workerPoolName")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "workerPoolName", valid_594435
  var valid_594436 = path.getOrDefault("subscriptionId")
  valid_594436 = validateParameter(valid_594436, JString, required = true,
                                 default = nil)
  if valid_594436 != nil:
    section.add "subscriptionId", valid_594436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594437 = query.getOrDefault("api-version")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "api-version", valid_594437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594438: Call_AppServiceEnvironmentsListWorkerPoolSkus_594430;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get available SKUs for scaling a worker pool.
  ## 
  let valid = call_594438.validator(path, query, header, formData, body)
  let scheme = call_594438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594438.url(scheme.get, call_594438.host, call_594438.base,
                         call_594438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594438, url, valid)

proc call*(call_594439: Call_AppServiceEnvironmentsListWorkerPoolSkus_594430;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListWorkerPoolSkus
  ## Get available SKUs for scaling a worker pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594440 = newJObject()
  var query_594441 = newJObject()
  add(path_594440, "resourceGroupName", newJString(resourceGroupName))
  add(query_594441, "api-version", newJString(apiVersion))
  add(path_594440, "name", newJString(name))
  add(path_594440, "workerPoolName", newJString(workerPoolName))
  add(path_594440, "subscriptionId", newJString(subscriptionId))
  result = call_594439.call(path_594440, query_594441, nil, nil, nil)

var appServiceEnvironmentsListWorkerPoolSkus* = Call_AppServiceEnvironmentsListWorkerPoolSkus_594430(
    name: "appServiceEnvironmentsListWorkerPoolSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/skus",
    validator: validate_AppServiceEnvironmentsListWorkerPoolSkus_594431, base: "",
    url: url_AppServiceEnvironmentsListWorkerPoolSkus_594432,
    schemes: {Scheme.Https})
type
  Call_AppServiceEnvironmentsListWebWorkerUsages_594442 = ref object of OpenApiRestCall_593426
proc url_AppServiceEnvironmentsListWebWorkerUsages_594444(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "workerPoolName" in path, "`workerPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/workerPools/"),
               (kind: VariableSegment, value: "workerPoolName"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceEnvironmentsListWebWorkerUsages_594443(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get usage metrics for a worker pool of an App Service Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: JString (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594445 = path.getOrDefault("resourceGroupName")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "resourceGroupName", valid_594445
  var valid_594446 = path.getOrDefault("name")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "name", valid_594446
  var valid_594447 = path.getOrDefault("workerPoolName")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "workerPoolName", valid_594447
  var valid_594448 = path.getOrDefault("subscriptionId")
  valid_594448 = validateParameter(valid_594448, JString, required = true,
                                 default = nil)
  if valid_594448 != nil:
    section.add "subscriptionId", valid_594448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594449 = query.getOrDefault("api-version")
  valid_594449 = validateParameter(valid_594449, JString, required = true,
                                 default = nil)
  if valid_594449 != nil:
    section.add "api-version", valid_594449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594450: Call_AppServiceEnvironmentsListWebWorkerUsages_594442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get usage metrics for a worker pool of an App Service Environment.
  ## 
  let valid = call_594450.validator(path, query, header, formData, body)
  let scheme = call_594450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594450.url(scheme.get, call_594450.host, call_594450.base,
                         call_594450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594450, url, valid)

proc call*(call_594451: Call_AppServiceEnvironmentsListWebWorkerUsages_594442;
          resourceGroupName: string; apiVersion: string; name: string;
          workerPoolName: string; subscriptionId: string): Recallable =
  ## appServiceEnvironmentsListWebWorkerUsages
  ## Get usage metrics for a worker pool of an App Service Environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the App Service Environment.
  ##   workerPoolName: string (required)
  ##                 : Name of the worker pool.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594452 = newJObject()
  var query_594453 = newJObject()
  add(path_594452, "resourceGroupName", newJString(resourceGroupName))
  add(query_594453, "api-version", newJString(apiVersion))
  add(path_594452, "name", newJString(name))
  add(path_594452, "workerPoolName", newJString(workerPoolName))
  add(path_594452, "subscriptionId", newJString(subscriptionId))
  result = call_594451.call(path_594452, query_594453, nil, nil, nil)

var appServiceEnvironmentsListWebWorkerUsages* = Call_AppServiceEnvironmentsListWebWorkerUsages_594442(
    name: "appServiceEnvironmentsListWebWorkerUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/workerPools/{workerPoolName}/usages",
    validator: validate_AppServiceEnvironmentsListWebWorkerUsages_594443,
    base: "", url: url_AppServiceEnvironmentsListWebWorkerUsages_594444,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
