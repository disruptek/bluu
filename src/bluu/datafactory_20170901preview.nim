
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DataFactoryManagementClient
## version: 2017-09-01-preview
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

  OpenApiRestCall_567668 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567668](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567668): Option[Scheme] {.used.} =
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
  macServiceName = "datafactory"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567890 = ref object of OpenApiRestCall_567668
proc url_OperationsList_567892(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567891(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists the available Azure Data Factory API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568051 = query.getOrDefault("api-version")
  valid_568051 = validateParameter(valid_568051, JString, required = true,
                                 default = nil)
  if valid_568051 != nil:
    section.add "api-version", valid_568051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568074: Call_OperationsList_567890; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available Azure Data Factory API operations.
  ## 
  let valid = call_568074.validator(path, query, header, formData, body)
  let scheme = call_568074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568074.url(scheme.get, call_568074.host, call_568074.base,
                         call_568074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568074, url, valid)

proc call*(call_568145: Call_OperationsList_567890; apiVersion: string): Recallable =
  ## operationsList
  ## Lists the available Azure Data Factory API operations.
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_568146 = newJObject()
  add(query_568146, "api-version", newJString(apiVersion))
  result = call_568145.call(nil, query_568146, nil, nil, nil)

var operationsList* = Call_OperationsList_567890(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataFactory/operations",
    validator: validate_OperationsList_567891, base: "", url: url_OperationsList_567892,
    schemes: {Scheme.Https})
type
  Call_FactoriesList_568186 = ref object of OpenApiRestCall_567668
proc url_FactoriesList_568188(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataFactory/factories")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesList_568187(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists factories under the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568203 = path.getOrDefault("subscriptionId")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "subscriptionId", valid_568203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568204 = query.getOrDefault("api-version")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "api-version", valid_568204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568205: Call_FactoriesList_568186; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists factories under the specified subscription.
  ## 
  let valid = call_568205.validator(path, query, header, formData, body)
  let scheme = call_568205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568205.url(scheme.get, call_568205.host, call_568205.base,
                         call_568205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568205, url, valid)

proc call*(call_568206: Call_FactoriesList_568186; apiVersion: string;
          subscriptionId: string): Recallable =
  ## factoriesList
  ## Lists factories under the specified subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568207 = newJObject()
  var query_568208 = newJObject()
  add(query_568208, "api-version", newJString(apiVersion))
  add(path_568207, "subscriptionId", newJString(subscriptionId))
  result = call_568206.call(path_568207, query_568208, nil, nil, nil)

var factoriesList* = Call_FactoriesList_568186(name: "factoriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataFactory/factories",
    validator: validate_FactoriesList_568187, base: "", url: url_FactoriesList_568188,
    schemes: {Scheme.Https})
type
  Call_FactoriesConfigureFactoryRepo_568209 = ref object of OpenApiRestCall_567668
proc url_FactoriesConfigureFactoryRepo_568211(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationId" in path, "`locationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/locations/"),
               (kind: VariableSegment, value: "locationId"),
               (kind: ConstantSegment, value: "/configureFactoryRepo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesConfigureFactoryRepo_568210(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a factory's repo information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationId: JString (required)
  ##             : The location identifier.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationId` field"
  var valid_568229 = path.getOrDefault("locationId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "locationId", valid_568229
  var valid_568230 = path.getOrDefault("subscriptionId")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "subscriptionId", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   factoryRepoUpdate: JObject (required)
  ##                    : Update factory repo request definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_FactoriesConfigureFactoryRepo_568209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a factory's repo information.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_FactoriesConfigureFactoryRepo_568209;
          apiVersion: string; locationId: string; subscriptionId: string;
          factoryRepoUpdate: JsonNode): Recallable =
  ## factoriesConfigureFactoryRepo
  ## Updates a factory's repo information.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   locationId: string (required)
  ##             : The location identifier.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   factoryRepoUpdate: JObject (required)
  ##                    : Update factory repo request definition.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  var body_568237 = newJObject()
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "locationId", newJString(locationId))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  if factoryRepoUpdate != nil:
    body_568237 = factoryRepoUpdate
  result = call_568234.call(path_568235, query_568236, nil, nil, body_568237)

var factoriesConfigureFactoryRepo* = Call_FactoriesConfigureFactoryRepo_568209(
    name: "factoriesConfigureFactoryRepo", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataFactory/locations/{locationId}/configureFactoryRepo",
    validator: validate_FactoriesConfigureFactoryRepo_568210, base: "",
    url: url_FactoriesConfigureFactoryRepo_568211, schemes: {Scheme.Https})
type
  Call_FactoriesListByResourceGroup_568238 = ref object of OpenApiRestCall_567668
proc url_FactoriesListByResourceGroup_568240(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.DataFactory/factories")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesListByResourceGroup_568239(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists factories.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568241 = path.getOrDefault("resourceGroupName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "resourceGroupName", valid_568241
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_FactoriesListByResourceGroup_568238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists factories.
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_FactoriesListByResourceGroup_568238;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## factoriesListByResourceGroup
  ## Lists factories.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  add(path_568246, "resourceGroupName", newJString(resourceGroupName))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  result = call_568245.call(path_568246, query_568247, nil, nil, nil)

var factoriesListByResourceGroup* = Call_FactoriesListByResourceGroup_568238(
    name: "factoriesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories",
    validator: validate_FactoriesListByResourceGroup_568239, base: "",
    url: url_FactoriesListByResourceGroup_568240, schemes: {Scheme.Https})
type
  Call_FactoriesCreateOrUpdate_568259 = ref object of OpenApiRestCall_567668
proc url_FactoriesCreateOrUpdate_568261(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesCreateOrUpdate_568260(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a factory.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568262 = path.getOrDefault("resourceGroupName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "resourceGroupName", valid_568262
  var valid_568263 = path.getOrDefault("factoryName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "factoryName", valid_568263
  var valid_568264 = path.getOrDefault("subscriptionId")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "subscriptionId", valid_568264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568265 = query.getOrDefault("api-version")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "api-version", valid_568265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   factory: JObject (required)
  ##          : Factory resource definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568267: Call_FactoriesCreateOrUpdate_568259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a factory.
  ## 
  let valid = call_568267.validator(path, query, header, formData, body)
  let scheme = call_568267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568267.url(scheme.get, call_568267.host, call_568267.base,
                         call_568267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568267, url, valid)

proc call*(call_568268: Call_FactoriesCreateOrUpdate_568259;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; factory: JsonNode): Recallable =
  ## factoriesCreateOrUpdate
  ## Creates or updates a factory.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   factory: JObject (required)
  ##          : Factory resource definition.
  var path_568269 = newJObject()
  var query_568270 = newJObject()
  var body_568271 = newJObject()
  add(path_568269, "resourceGroupName", newJString(resourceGroupName))
  add(path_568269, "factoryName", newJString(factoryName))
  add(query_568270, "api-version", newJString(apiVersion))
  add(path_568269, "subscriptionId", newJString(subscriptionId))
  if factory != nil:
    body_568271 = factory
  result = call_568268.call(path_568269, query_568270, nil, nil, body_568271)

var factoriesCreateOrUpdate* = Call_FactoriesCreateOrUpdate_568259(
    name: "factoriesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesCreateOrUpdate_568260, base: "",
    url: url_FactoriesCreateOrUpdate_568261, schemes: {Scheme.Https})
type
  Call_FactoriesGet_568248 = ref object of OpenApiRestCall_567668
proc url_FactoriesGet_568250(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesGet_568249(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a factory.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568251 = path.getOrDefault("resourceGroupName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "resourceGroupName", valid_568251
  var valid_568252 = path.getOrDefault("factoryName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "factoryName", valid_568252
  var valid_568253 = path.getOrDefault("subscriptionId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "subscriptionId", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568254 = query.getOrDefault("api-version")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "api-version", valid_568254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568255: Call_FactoriesGet_568248; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a factory.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_FactoriesGet_568248; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## factoriesGet
  ## Gets a factory.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  add(path_568257, "resourceGroupName", newJString(resourceGroupName))
  add(path_568257, "factoryName", newJString(factoryName))
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  result = call_568256.call(path_568257, query_568258, nil, nil, nil)

var factoriesGet* = Call_FactoriesGet_568248(name: "factoriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesGet_568249, base: "", url: url_FactoriesGet_568250,
    schemes: {Scheme.Https})
type
  Call_FactoriesUpdate_568283 = ref object of OpenApiRestCall_567668
proc url_FactoriesUpdate_568285(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesUpdate_568284(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a factory.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568286 = path.getOrDefault("resourceGroupName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "resourceGroupName", valid_568286
  var valid_568287 = path.getOrDefault("factoryName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "factoryName", valid_568287
  var valid_568288 = path.getOrDefault("subscriptionId")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "subscriptionId", valid_568288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568289 = query.getOrDefault("api-version")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "api-version", valid_568289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   factoryUpdateParameters: JObject (required)
  ##                          : The parameters for updating a factory.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568291: Call_FactoriesUpdate_568283; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a factory.
  ## 
  let valid = call_568291.validator(path, query, header, formData, body)
  let scheme = call_568291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568291.url(scheme.get, call_568291.host, call_568291.base,
                         call_568291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568291, url, valid)

proc call*(call_568292: Call_FactoriesUpdate_568283; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          factoryUpdateParameters: JsonNode): Recallable =
  ## factoriesUpdate
  ## Updates a factory.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   factoryUpdateParameters: JObject (required)
  ##                          : The parameters for updating a factory.
  var path_568293 = newJObject()
  var query_568294 = newJObject()
  var body_568295 = newJObject()
  add(path_568293, "resourceGroupName", newJString(resourceGroupName))
  add(path_568293, "factoryName", newJString(factoryName))
  add(query_568294, "api-version", newJString(apiVersion))
  add(path_568293, "subscriptionId", newJString(subscriptionId))
  if factoryUpdateParameters != nil:
    body_568295 = factoryUpdateParameters
  result = call_568292.call(path_568293, query_568294, nil, nil, body_568295)

var factoriesUpdate* = Call_FactoriesUpdate_568283(name: "factoriesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesUpdate_568284, base: "", url: url_FactoriesUpdate_568285,
    schemes: {Scheme.Https})
type
  Call_FactoriesDelete_568272 = ref object of OpenApiRestCall_567668
proc url_FactoriesDelete_568274(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesDelete_568273(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a factory.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568275 = path.getOrDefault("resourceGroupName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "resourceGroupName", valid_568275
  var valid_568276 = path.getOrDefault("factoryName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "factoryName", valid_568276
  var valid_568277 = path.getOrDefault("subscriptionId")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "subscriptionId", valid_568277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568278 = query.getOrDefault("api-version")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "api-version", valid_568278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568279: Call_FactoriesDelete_568272; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a factory.
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_FactoriesDelete_568272; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## factoriesDelete
  ## Deletes a factory.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  add(path_568281, "resourceGroupName", newJString(resourceGroupName))
  add(path_568281, "factoryName", newJString(factoryName))
  add(query_568282, "api-version", newJString(apiVersion))
  add(path_568281, "subscriptionId", newJString(subscriptionId))
  result = call_568280.call(path_568281, query_568282, nil, nil, nil)

var factoriesDelete* = Call_FactoriesDelete_568272(name: "factoriesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesDelete_568273, base: "", url: url_FactoriesDelete_568274,
    schemes: {Scheme.Https})
type
  Call_FactoriesCancelPipelineRun_568296 = ref object of OpenApiRestCall_567668
proc url_FactoriesCancelPipelineRun_568298(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/cancelpipelinerun/"),
               (kind: VariableSegment, value: "runId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesCancelPipelineRun_568297(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel a pipeline run by its run ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   runId: JString (required)
  ##        : The pipeline run identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568299 = path.getOrDefault("resourceGroupName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "resourceGroupName", valid_568299
  var valid_568300 = path.getOrDefault("factoryName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "factoryName", valid_568300
  var valid_568301 = path.getOrDefault("subscriptionId")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "subscriptionId", valid_568301
  var valid_568302 = path.getOrDefault("runId")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "runId", valid_568302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568303 = query.getOrDefault("api-version")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "api-version", valid_568303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568304: Call_FactoriesCancelPipelineRun_568296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a pipeline run by its run ID.
  ## 
  let valid = call_568304.validator(path, query, header, formData, body)
  let scheme = call_568304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568304.url(scheme.get, call_568304.host, call_568304.base,
                         call_568304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568304, url, valid)

proc call*(call_568305: Call_FactoriesCancelPipelineRun_568296;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; runId: string): Recallable =
  ## factoriesCancelPipelineRun
  ## Cancel a pipeline run by its run ID.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   runId: string (required)
  ##        : The pipeline run identifier.
  var path_568306 = newJObject()
  var query_568307 = newJObject()
  add(path_568306, "resourceGroupName", newJString(resourceGroupName))
  add(path_568306, "factoryName", newJString(factoryName))
  add(query_568307, "api-version", newJString(apiVersion))
  add(path_568306, "subscriptionId", newJString(subscriptionId))
  add(path_568306, "runId", newJString(runId))
  result = call_568305.call(path_568306, query_568307, nil, nil, nil)

var factoriesCancelPipelineRun* = Call_FactoriesCancelPipelineRun_568296(
    name: "factoriesCancelPipelineRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/cancelpipelinerun/{runId}",
    validator: validate_FactoriesCancelPipelineRun_568297, base: "",
    url: url_FactoriesCancelPipelineRun_568298, schemes: {Scheme.Https})
type
  Call_DatasetsListByFactory_568308 = ref object of OpenApiRestCall_567668
proc url_DatasetsListByFactory_568310(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/datasets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatasetsListByFactory_568309(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists datasets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568311 = path.getOrDefault("resourceGroupName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "resourceGroupName", valid_568311
  var valid_568312 = path.getOrDefault("factoryName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "factoryName", valid_568312
  var valid_568313 = path.getOrDefault("subscriptionId")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "subscriptionId", valid_568313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568314 = query.getOrDefault("api-version")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "api-version", valid_568314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568315: Call_DatasetsListByFactory_568308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists datasets.
  ## 
  let valid = call_568315.validator(path, query, header, formData, body)
  let scheme = call_568315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568315.url(scheme.get, call_568315.host, call_568315.base,
                         call_568315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568315, url, valid)

proc call*(call_568316: Call_DatasetsListByFactory_568308;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## datasetsListByFactory
  ## Lists datasets.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568317 = newJObject()
  var query_568318 = newJObject()
  add(path_568317, "resourceGroupName", newJString(resourceGroupName))
  add(path_568317, "factoryName", newJString(factoryName))
  add(query_568318, "api-version", newJString(apiVersion))
  add(path_568317, "subscriptionId", newJString(subscriptionId))
  result = call_568316.call(path_568317, query_568318, nil, nil, nil)

var datasetsListByFactory* = Call_DatasetsListByFactory_568308(
    name: "datasetsListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets",
    validator: validate_DatasetsListByFactory_568309, base: "",
    url: url_DatasetsListByFactory_568310, schemes: {Scheme.Https})
type
  Call_DatasetsCreateOrUpdate_568331 = ref object of OpenApiRestCall_567668
proc url_DatasetsCreateOrUpdate_568333(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "datasetName" in path, "`datasetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatasetsCreateOrUpdate_568332(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   datasetName: JString (required)
  ##              : The dataset name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568334 = path.getOrDefault("resourceGroupName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "resourceGroupName", valid_568334
  var valid_568335 = path.getOrDefault("factoryName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "factoryName", valid_568335
  var valid_568336 = path.getOrDefault("subscriptionId")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "subscriptionId", valid_568336
  var valid_568337 = path.getOrDefault("datasetName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "datasetName", valid_568337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568338 = query.getOrDefault("api-version")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "api-version", valid_568338
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the dataset entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_568339 = header.getOrDefault("If-Match")
  valid_568339 = validateParameter(valid_568339, JString, required = false,
                                 default = nil)
  if valid_568339 != nil:
    section.add "If-Match", valid_568339
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dataset: JObject (required)
  ##          : Dataset resource definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568341: Call_DatasetsCreateOrUpdate_568331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a dataset.
  ## 
  let valid = call_568341.validator(path, query, header, formData, body)
  let scheme = call_568341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568341.url(scheme.get, call_568341.host, call_568341.base,
                         call_568341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568341, url, valid)

proc call*(call_568342: Call_DatasetsCreateOrUpdate_568331;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; datasetName: string; dataset: JsonNode): Recallable =
  ## datasetsCreateOrUpdate
  ## Creates or updates a dataset.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   datasetName: string (required)
  ##              : The dataset name.
  ##   dataset: JObject (required)
  ##          : Dataset resource definition.
  var path_568343 = newJObject()
  var query_568344 = newJObject()
  var body_568345 = newJObject()
  add(path_568343, "resourceGroupName", newJString(resourceGroupName))
  add(path_568343, "factoryName", newJString(factoryName))
  add(query_568344, "api-version", newJString(apiVersion))
  add(path_568343, "subscriptionId", newJString(subscriptionId))
  add(path_568343, "datasetName", newJString(datasetName))
  if dataset != nil:
    body_568345 = dataset
  result = call_568342.call(path_568343, query_568344, nil, nil, body_568345)

var datasetsCreateOrUpdate* = Call_DatasetsCreateOrUpdate_568331(
    name: "datasetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
    validator: validate_DatasetsCreateOrUpdate_568332, base: "",
    url: url_DatasetsCreateOrUpdate_568333, schemes: {Scheme.Https})
type
  Call_DatasetsGet_568319 = ref object of OpenApiRestCall_567668
proc url_DatasetsGet_568321(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "datasetName" in path, "`datasetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatasetsGet_568320(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   datasetName: JString (required)
  ##              : The dataset name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568322 = path.getOrDefault("resourceGroupName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "resourceGroupName", valid_568322
  var valid_568323 = path.getOrDefault("factoryName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "factoryName", valid_568323
  var valid_568324 = path.getOrDefault("subscriptionId")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "subscriptionId", valid_568324
  var valid_568325 = path.getOrDefault("datasetName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "datasetName", valid_568325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568326 = query.getOrDefault("api-version")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "api-version", valid_568326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568327: Call_DatasetsGet_568319; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a dataset.
  ## 
  let valid = call_568327.validator(path, query, header, formData, body)
  let scheme = call_568327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568327.url(scheme.get, call_568327.host, call_568327.base,
                         call_568327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568327, url, valid)

proc call*(call_568328: Call_DatasetsGet_568319; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          datasetName: string): Recallable =
  ## datasetsGet
  ## Gets a dataset.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   datasetName: string (required)
  ##              : The dataset name.
  var path_568329 = newJObject()
  var query_568330 = newJObject()
  add(path_568329, "resourceGroupName", newJString(resourceGroupName))
  add(path_568329, "factoryName", newJString(factoryName))
  add(query_568330, "api-version", newJString(apiVersion))
  add(path_568329, "subscriptionId", newJString(subscriptionId))
  add(path_568329, "datasetName", newJString(datasetName))
  result = call_568328.call(path_568329, query_568330, nil, nil, nil)

var datasetsGet* = Call_DatasetsGet_568319(name: "datasetsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
                                        validator: validate_DatasetsGet_568320,
                                        base: "", url: url_DatasetsGet_568321,
                                        schemes: {Scheme.Https})
type
  Call_DatasetsDelete_568346 = ref object of OpenApiRestCall_567668
proc url_DatasetsDelete_568348(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "datasetName" in path, "`datasetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatasetsDelete_568347(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   datasetName: JString (required)
  ##              : The dataset name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568349 = path.getOrDefault("resourceGroupName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "resourceGroupName", valid_568349
  var valid_568350 = path.getOrDefault("factoryName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "factoryName", valid_568350
  var valid_568351 = path.getOrDefault("subscriptionId")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "subscriptionId", valid_568351
  var valid_568352 = path.getOrDefault("datasetName")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "datasetName", valid_568352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568353 = query.getOrDefault("api-version")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "api-version", valid_568353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568354: Call_DatasetsDelete_568346; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a dataset.
  ## 
  let valid = call_568354.validator(path, query, header, formData, body)
  let scheme = call_568354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568354.url(scheme.get, call_568354.host, call_568354.base,
                         call_568354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568354, url, valid)

proc call*(call_568355: Call_DatasetsDelete_568346; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          datasetName: string): Recallable =
  ## datasetsDelete
  ## Deletes a dataset.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   datasetName: string (required)
  ##              : The dataset name.
  var path_568356 = newJObject()
  var query_568357 = newJObject()
  add(path_568356, "resourceGroupName", newJString(resourceGroupName))
  add(path_568356, "factoryName", newJString(factoryName))
  add(query_568357, "api-version", newJString(apiVersion))
  add(path_568356, "subscriptionId", newJString(subscriptionId))
  add(path_568356, "datasetName", newJString(datasetName))
  result = call_568355.call(path_568356, query_568357, nil, nil, nil)

var datasetsDelete* = Call_DatasetsDelete_568346(name: "datasetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
    validator: validate_DatasetsDelete_568347, base: "", url: url_DatasetsDelete_568348,
    schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesListByFactory_568358 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesListByFactory_568360(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesListByFactory_568359(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists integration runtimes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568361 = path.getOrDefault("resourceGroupName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "resourceGroupName", valid_568361
  var valid_568362 = path.getOrDefault("factoryName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "factoryName", valid_568362
  var valid_568363 = path.getOrDefault("subscriptionId")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "subscriptionId", valid_568363
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568364 = query.getOrDefault("api-version")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "api-version", valid_568364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568365: Call_IntegrationRuntimesListByFactory_568358;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists integration runtimes.
  ## 
  let valid = call_568365.validator(path, query, header, formData, body)
  let scheme = call_568365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568365.url(scheme.get, call_568365.host, call_568365.base,
                         call_568365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568365, url, valid)

proc call*(call_568366: Call_IntegrationRuntimesListByFactory_568358;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## integrationRuntimesListByFactory
  ## Lists integration runtimes.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568367 = newJObject()
  var query_568368 = newJObject()
  add(path_568367, "resourceGroupName", newJString(resourceGroupName))
  add(path_568367, "factoryName", newJString(factoryName))
  add(query_568368, "api-version", newJString(apiVersion))
  add(path_568367, "subscriptionId", newJString(subscriptionId))
  result = call_568366.call(path_568367, query_568368, nil, nil, nil)

var integrationRuntimesListByFactory* = Call_IntegrationRuntimesListByFactory_568358(
    name: "integrationRuntimesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes",
    validator: validate_IntegrationRuntimesListByFactory_568359, base: "",
    url: url_IntegrationRuntimesListByFactory_568360, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesCreateOrUpdate_568381 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesCreateOrUpdate_568383(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesCreateOrUpdate_568382(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568384 = path.getOrDefault("resourceGroupName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "resourceGroupName", valid_568384
  var valid_568385 = path.getOrDefault("factoryName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "factoryName", valid_568385
  var valid_568386 = path.getOrDefault("integrationRuntimeName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "integrationRuntimeName", valid_568386
  var valid_568387 = path.getOrDefault("subscriptionId")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "subscriptionId", valid_568387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568388 = query.getOrDefault("api-version")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "api-version", valid_568388
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the integration runtime entity. Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_568389 = header.getOrDefault("If-Match")
  valid_568389 = validateParameter(valid_568389, JString, required = false,
                                 default = nil)
  if valid_568389 != nil:
    section.add "If-Match", valid_568389
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   integrationRuntime: JObject (required)
  ##                     : Integration runtime resource definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568391: Call_IntegrationRuntimesCreateOrUpdate_568381;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration runtime.
  ## 
  let valid = call_568391.validator(path, query, header, formData, body)
  let scheme = call_568391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568391.url(scheme.get, call_568391.host, call_568391.base,
                         call_568391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568391, url, valid)

proc call*(call_568392: Call_IntegrationRuntimesCreateOrUpdate_568381;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string;
          integrationRuntime: JsonNode): Recallable =
  ## integrationRuntimesCreateOrUpdate
  ## Creates or updates an integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   integrationRuntime: JObject (required)
  ##                     : Integration runtime resource definition.
  var path_568393 = newJObject()
  var query_568394 = newJObject()
  var body_568395 = newJObject()
  add(path_568393, "resourceGroupName", newJString(resourceGroupName))
  add(path_568393, "factoryName", newJString(factoryName))
  add(query_568394, "api-version", newJString(apiVersion))
  add(path_568393, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568393, "subscriptionId", newJString(subscriptionId))
  if integrationRuntime != nil:
    body_568395 = integrationRuntime
  result = call_568392.call(path_568393, query_568394, nil, nil, body_568395)

var integrationRuntimesCreateOrUpdate* = Call_IntegrationRuntimesCreateOrUpdate_568381(
    name: "integrationRuntimesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesCreateOrUpdate_568382, base: "",
    url: url_IntegrationRuntimesCreateOrUpdate_568383, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGet_568369 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesGet_568371(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesGet_568370(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568372 = path.getOrDefault("resourceGroupName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "resourceGroupName", valid_568372
  var valid_568373 = path.getOrDefault("factoryName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "factoryName", valid_568373
  var valid_568374 = path.getOrDefault("integrationRuntimeName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "integrationRuntimeName", valid_568374
  var valid_568375 = path.getOrDefault("subscriptionId")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "subscriptionId", valid_568375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568376 = query.getOrDefault("api-version")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "api-version", valid_568376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568377: Call_IntegrationRuntimesGet_568369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration runtime.
  ## 
  let valid = call_568377.validator(path, query, header, formData, body)
  let scheme = call_568377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568377.url(scheme.get, call_568377.host, call_568377.base,
                         call_568377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568377, url, valid)

proc call*(call_568378: Call_IntegrationRuntimesGet_568369;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesGet
  ## Gets an integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568379 = newJObject()
  var query_568380 = newJObject()
  add(path_568379, "resourceGroupName", newJString(resourceGroupName))
  add(path_568379, "factoryName", newJString(factoryName))
  add(query_568380, "api-version", newJString(apiVersion))
  add(path_568379, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568379, "subscriptionId", newJString(subscriptionId))
  result = call_568378.call(path_568379, query_568380, nil, nil, nil)

var integrationRuntimesGet* = Call_IntegrationRuntimesGet_568369(
    name: "integrationRuntimesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesGet_568370, base: "",
    url: url_IntegrationRuntimesGet_568371, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesUpdate_568408 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesUpdate_568410(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesUpdate_568409(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568411 = path.getOrDefault("resourceGroupName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "resourceGroupName", valid_568411
  var valid_568412 = path.getOrDefault("factoryName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "factoryName", valid_568412
  var valid_568413 = path.getOrDefault("integrationRuntimeName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "integrationRuntimeName", valid_568413
  var valid_568414 = path.getOrDefault("subscriptionId")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "subscriptionId", valid_568414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  ## parameters in `body` object:
  ##   updateIntegrationRuntimeRequest: JObject (required)
  ##                                  : The parameters for updating an integration runtime.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568417: Call_IntegrationRuntimesUpdate_568408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an integration runtime.
  ## 
  let valid = call_568417.validator(path, query, header, formData, body)
  let scheme = call_568417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568417.url(scheme.get, call_568417.host, call_568417.base,
                         call_568417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568417, url, valid)

proc call*(call_568418: Call_IntegrationRuntimesUpdate_568408;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string;
          updateIntegrationRuntimeRequest: JsonNode): Recallable =
  ## integrationRuntimesUpdate
  ## Updates an integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   updateIntegrationRuntimeRequest: JObject (required)
  ##                                  : The parameters for updating an integration runtime.
  var path_568419 = newJObject()
  var query_568420 = newJObject()
  var body_568421 = newJObject()
  add(path_568419, "resourceGroupName", newJString(resourceGroupName))
  add(path_568419, "factoryName", newJString(factoryName))
  add(query_568420, "api-version", newJString(apiVersion))
  add(path_568419, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568419, "subscriptionId", newJString(subscriptionId))
  if updateIntegrationRuntimeRequest != nil:
    body_568421 = updateIntegrationRuntimeRequest
  result = call_568418.call(path_568419, query_568420, nil, nil, body_568421)

var integrationRuntimesUpdate* = Call_IntegrationRuntimesUpdate_568408(
    name: "integrationRuntimesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesUpdate_568409, base: "",
    url: url_IntegrationRuntimesUpdate_568410, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesDelete_568396 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesDelete_568398(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesDelete_568397(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568399 = path.getOrDefault("resourceGroupName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "resourceGroupName", valid_568399
  var valid_568400 = path.getOrDefault("factoryName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "factoryName", valid_568400
  var valid_568401 = path.getOrDefault("integrationRuntimeName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "integrationRuntimeName", valid_568401
  var valid_568402 = path.getOrDefault("subscriptionId")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "subscriptionId", valid_568402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568403 = query.getOrDefault("api-version")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "api-version", valid_568403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568404: Call_IntegrationRuntimesDelete_568396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration runtime.
  ## 
  let valid = call_568404.validator(path, query, header, formData, body)
  let scheme = call_568404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568404.url(scheme.get, call_568404.host, call_568404.base,
                         call_568404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568404, url, valid)

proc call*(call_568405: Call_IntegrationRuntimesDelete_568396;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesDelete
  ## Deletes an integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568406 = newJObject()
  var query_568407 = newJObject()
  add(path_568406, "resourceGroupName", newJString(resourceGroupName))
  add(path_568406, "factoryName", newJString(factoryName))
  add(query_568407, "api-version", newJString(apiVersion))
  add(path_568406, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568406, "subscriptionId", newJString(subscriptionId))
  result = call_568405.call(path_568406, query_568407, nil, nil, nil)

var integrationRuntimesDelete* = Call_IntegrationRuntimesDelete_568396(
    name: "integrationRuntimesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesDelete_568397, base: "",
    url: url_IntegrationRuntimesDelete_568398, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetConnectionInfo_568422 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesGetConnectionInfo_568424(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/getConnectionInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesGetConnectionInfo_568423(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the on-premises integration runtime connection information for encrypting the on-premises data source credentials.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568425 = path.getOrDefault("resourceGroupName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "resourceGroupName", valid_568425
  var valid_568426 = path.getOrDefault("factoryName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "factoryName", valid_568426
  var valid_568427 = path.getOrDefault("integrationRuntimeName")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "integrationRuntimeName", valid_568427
  var valid_568428 = path.getOrDefault("subscriptionId")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "subscriptionId", valid_568428
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568429 = query.getOrDefault("api-version")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "api-version", valid_568429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568430: Call_IntegrationRuntimesGetConnectionInfo_568422;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the on-premises integration runtime connection information for encrypting the on-premises data source credentials.
  ## 
  let valid = call_568430.validator(path, query, header, formData, body)
  let scheme = call_568430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568430.url(scheme.get, call_568430.host, call_568430.base,
                         call_568430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568430, url, valid)

proc call*(call_568431: Call_IntegrationRuntimesGetConnectionInfo_568422;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesGetConnectionInfo
  ## Gets the on-premises integration runtime connection information for encrypting the on-premises data source credentials.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568432 = newJObject()
  var query_568433 = newJObject()
  add(path_568432, "resourceGroupName", newJString(resourceGroupName))
  add(path_568432, "factoryName", newJString(factoryName))
  add(query_568433, "api-version", newJString(apiVersion))
  add(path_568432, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568432, "subscriptionId", newJString(subscriptionId))
  result = call_568431.call(path_568432, query_568433, nil, nil, nil)

var integrationRuntimesGetConnectionInfo* = Call_IntegrationRuntimesGetConnectionInfo_568422(
    name: "integrationRuntimesGetConnectionInfo", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/getConnectionInfo",
    validator: validate_IntegrationRuntimesGetConnectionInfo_568423, base: "",
    url: url_IntegrationRuntimesGetConnectionInfo_568424, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetStatus_568434 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesGetStatus_568436(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/getStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesGetStatus_568435(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets detailed status information for an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568437 = path.getOrDefault("resourceGroupName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "resourceGroupName", valid_568437
  var valid_568438 = path.getOrDefault("factoryName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "factoryName", valid_568438
  var valid_568439 = path.getOrDefault("integrationRuntimeName")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "integrationRuntimeName", valid_568439
  var valid_568440 = path.getOrDefault("subscriptionId")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "subscriptionId", valid_568440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568441 = query.getOrDefault("api-version")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "api-version", valid_568441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568442: Call_IntegrationRuntimesGetStatus_568434; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets detailed status information for an integration runtime.
  ## 
  let valid = call_568442.validator(path, query, header, formData, body)
  let scheme = call_568442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568442.url(scheme.get, call_568442.host, call_568442.base,
                         call_568442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568442, url, valid)

proc call*(call_568443: Call_IntegrationRuntimesGetStatus_568434;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesGetStatus
  ## Gets detailed status information for an integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568444 = newJObject()
  var query_568445 = newJObject()
  add(path_568444, "resourceGroupName", newJString(resourceGroupName))
  add(path_568444, "factoryName", newJString(factoryName))
  add(query_568445, "api-version", newJString(apiVersion))
  add(path_568444, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568444, "subscriptionId", newJString(subscriptionId))
  result = call_568443.call(path_568444, query_568445, nil, nil, nil)

var integrationRuntimesGetStatus* = Call_IntegrationRuntimesGetStatus_568434(
    name: "integrationRuntimesGetStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/getStatus",
    validator: validate_IntegrationRuntimesGetStatus_568435, base: "",
    url: url_IntegrationRuntimesGetStatus_568436, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesListAuthKeys_568446 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesListAuthKeys_568448(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/listAuthKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesListAuthKeys_568447(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the authentication keys for an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568449 = path.getOrDefault("resourceGroupName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "resourceGroupName", valid_568449
  var valid_568450 = path.getOrDefault("factoryName")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "factoryName", valid_568450
  var valid_568451 = path.getOrDefault("integrationRuntimeName")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "integrationRuntimeName", valid_568451
  var valid_568452 = path.getOrDefault("subscriptionId")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "subscriptionId", valid_568452
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568454: Call_IntegrationRuntimesListAuthKeys_568446;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the authentication keys for an integration runtime.
  ## 
  let valid = call_568454.validator(path, query, header, formData, body)
  let scheme = call_568454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568454.url(scheme.get, call_568454.host, call_568454.base,
                         call_568454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568454, url, valid)

proc call*(call_568455: Call_IntegrationRuntimesListAuthKeys_568446;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesListAuthKeys
  ## Retrieves the authentication keys for an integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568456 = newJObject()
  var query_568457 = newJObject()
  add(path_568456, "resourceGroupName", newJString(resourceGroupName))
  add(path_568456, "factoryName", newJString(factoryName))
  add(query_568457, "api-version", newJString(apiVersion))
  add(path_568456, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568456, "subscriptionId", newJString(subscriptionId))
  result = call_568455.call(path_568456, query_568457, nil, nil, nil)

var integrationRuntimesListAuthKeys* = Call_IntegrationRuntimesListAuthKeys_568446(
    name: "integrationRuntimesListAuthKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/listAuthKeys",
    validator: validate_IntegrationRuntimesListAuthKeys_568447, base: "",
    url: url_IntegrationRuntimesListAuthKeys_568448, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetMonitoringData_568458 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesGetMonitoringData_568460(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/monitoringData")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesGetMonitoringData_568459(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the integration runtime monitoring data, which includes the monitor data for all the nodes under this integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568461 = path.getOrDefault("resourceGroupName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "resourceGroupName", valid_568461
  var valid_568462 = path.getOrDefault("factoryName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "factoryName", valid_568462
  var valid_568463 = path.getOrDefault("integrationRuntimeName")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "integrationRuntimeName", valid_568463
  var valid_568464 = path.getOrDefault("subscriptionId")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "subscriptionId", valid_568464
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568465 = query.getOrDefault("api-version")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "api-version", valid_568465
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568466: Call_IntegrationRuntimesGetMonitoringData_568458;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the integration runtime monitoring data, which includes the monitor data for all the nodes under this integration runtime.
  ## 
  let valid = call_568466.validator(path, query, header, formData, body)
  let scheme = call_568466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568466.url(scheme.get, call_568466.host, call_568466.base,
                         call_568466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568466, url, valid)

proc call*(call_568467: Call_IntegrationRuntimesGetMonitoringData_568458;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesGetMonitoringData
  ## Get the integration runtime monitoring data, which includes the monitor data for all the nodes under this integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568468 = newJObject()
  var query_568469 = newJObject()
  add(path_568468, "resourceGroupName", newJString(resourceGroupName))
  add(path_568468, "factoryName", newJString(factoryName))
  add(query_568469, "api-version", newJString(apiVersion))
  add(path_568468, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568468, "subscriptionId", newJString(subscriptionId))
  result = call_568467.call(path_568468, query_568469, nil, nil, nil)

var integrationRuntimesGetMonitoringData* = Call_IntegrationRuntimesGetMonitoringData_568458(
    name: "integrationRuntimesGetMonitoringData", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/monitoringData",
    validator: validate_IntegrationRuntimesGetMonitoringData_568459, base: "",
    url: url_IntegrationRuntimesGetMonitoringData_568460, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesUpdate_568483 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimeNodesUpdate_568485(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimeNodesUpdate_568484(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a self-hosted integration runtime node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   nodeName: JString (required)
  ##           : The integration runtime node name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568486 = path.getOrDefault("resourceGroupName")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "resourceGroupName", valid_568486
  var valid_568487 = path.getOrDefault("factoryName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "factoryName", valid_568487
  var valid_568488 = path.getOrDefault("nodeName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "nodeName", valid_568488
  var valid_568489 = path.getOrDefault("integrationRuntimeName")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "integrationRuntimeName", valid_568489
  var valid_568490 = path.getOrDefault("subscriptionId")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "subscriptionId", valid_568490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568491 = query.getOrDefault("api-version")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "api-version", valid_568491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateIntegrationRuntimeNodeRequest: JObject (required)
  ##                                      : The parameters for updating an integration runtime node.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568493: Call_IntegrationRuntimeNodesUpdate_568483; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a self-hosted integration runtime node.
  ## 
  let valid = call_568493.validator(path, query, header, formData, body)
  let scheme = call_568493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568493.url(scheme.get, call_568493.host, call_568493.base,
                         call_568493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568493, url, valid)

proc call*(call_568494: Call_IntegrationRuntimeNodesUpdate_568483;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          nodeName: string; integrationRuntimeName: string; subscriptionId: string;
          updateIntegrationRuntimeNodeRequest: JsonNode): Recallable =
  ## integrationRuntimeNodesUpdate
  ## Updates a self-hosted integration runtime node.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   nodeName: string (required)
  ##           : The integration runtime node name.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   updateIntegrationRuntimeNodeRequest: JObject (required)
  ##                                      : The parameters for updating an integration runtime node.
  var path_568495 = newJObject()
  var query_568496 = newJObject()
  var body_568497 = newJObject()
  add(path_568495, "resourceGroupName", newJString(resourceGroupName))
  add(path_568495, "factoryName", newJString(factoryName))
  add(query_568496, "api-version", newJString(apiVersion))
  add(path_568495, "nodeName", newJString(nodeName))
  add(path_568495, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568495, "subscriptionId", newJString(subscriptionId))
  if updateIntegrationRuntimeNodeRequest != nil:
    body_568497 = updateIntegrationRuntimeNodeRequest
  result = call_568494.call(path_568495, query_568496, nil, nil, body_568497)

var integrationRuntimeNodesUpdate* = Call_IntegrationRuntimeNodesUpdate_568483(
    name: "integrationRuntimeNodesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}",
    validator: validate_IntegrationRuntimeNodesUpdate_568484, base: "",
    url: url_IntegrationRuntimeNodesUpdate_568485, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesDelete_568470 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimeNodesDelete_568472(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimeNodesDelete_568471(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a self-hosted integration runtime node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   nodeName: JString (required)
  ##           : The integration runtime node name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568473 = path.getOrDefault("resourceGroupName")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "resourceGroupName", valid_568473
  var valid_568474 = path.getOrDefault("factoryName")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "factoryName", valid_568474
  var valid_568475 = path.getOrDefault("nodeName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "nodeName", valid_568475
  var valid_568476 = path.getOrDefault("integrationRuntimeName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "integrationRuntimeName", valid_568476
  var valid_568477 = path.getOrDefault("subscriptionId")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "subscriptionId", valid_568477
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568478 = query.getOrDefault("api-version")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "api-version", valid_568478
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568479: Call_IntegrationRuntimeNodesDelete_568470; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a self-hosted integration runtime node.
  ## 
  let valid = call_568479.validator(path, query, header, formData, body)
  let scheme = call_568479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568479.url(scheme.get, call_568479.host, call_568479.base,
                         call_568479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568479, url, valid)

proc call*(call_568480: Call_IntegrationRuntimeNodesDelete_568470;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          nodeName: string; integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimeNodesDelete
  ## Deletes a self-hosted integration runtime node.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   nodeName: string (required)
  ##           : The integration runtime node name.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568481 = newJObject()
  var query_568482 = newJObject()
  add(path_568481, "resourceGroupName", newJString(resourceGroupName))
  add(path_568481, "factoryName", newJString(factoryName))
  add(query_568482, "api-version", newJString(apiVersion))
  add(path_568481, "nodeName", newJString(nodeName))
  add(path_568481, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568481, "subscriptionId", newJString(subscriptionId))
  result = call_568480.call(path_568481, query_568482, nil, nil, nil)

var integrationRuntimeNodesDelete* = Call_IntegrationRuntimeNodesDelete_568470(
    name: "integrationRuntimeNodesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}",
    validator: validate_IntegrationRuntimeNodesDelete_568471, base: "",
    url: url_IntegrationRuntimeNodesDelete_568472, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesGetIpAddress_568498 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimeNodesGetIpAddress_568500(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/ipAddress")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimeNodesGetIpAddress_568499(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the IP address of self-hosted integration runtime node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   nodeName: JString (required)
  ##           : The integration runtime node name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568501 = path.getOrDefault("resourceGroupName")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "resourceGroupName", valid_568501
  var valid_568502 = path.getOrDefault("factoryName")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "factoryName", valid_568502
  var valid_568503 = path.getOrDefault("nodeName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "nodeName", valid_568503
  var valid_568504 = path.getOrDefault("integrationRuntimeName")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "integrationRuntimeName", valid_568504
  var valid_568505 = path.getOrDefault("subscriptionId")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "subscriptionId", valid_568505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568506 = query.getOrDefault("api-version")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "api-version", valid_568506
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568507: Call_IntegrationRuntimeNodesGetIpAddress_568498;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IP address of self-hosted integration runtime node.
  ## 
  let valid = call_568507.validator(path, query, header, formData, body)
  let scheme = call_568507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568507.url(scheme.get, call_568507.host, call_568507.base,
                         call_568507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568507, url, valid)

proc call*(call_568508: Call_IntegrationRuntimeNodesGetIpAddress_568498;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          nodeName: string; integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimeNodesGetIpAddress
  ## Get the IP address of self-hosted integration runtime node.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   nodeName: string (required)
  ##           : The integration runtime node name.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568509 = newJObject()
  var query_568510 = newJObject()
  add(path_568509, "resourceGroupName", newJString(resourceGroupName))
  add(path_568509, "factoryName", newJString(factoryName))
  add(query_568510, "api-version", newJString(apiVersion))
  add(path_568509, "nodeName", newJString(nodeName))
  add(path_568509, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568509, "subscriptionId", newJString(subscriptionId))
  result = call_568508.call(path_568509, query_568510, nil, nil, nil)

var integrationRuntimeNodesGetIpAddress* = Call_IntegrationRuntimeNodesGetIpAddress_568498(
    name: "integrationRuntimeNodesGetIpAddress", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}/ipAddress",
    validator: validate_IntegrationRuntimeNodesGetIpAddress_568499, base: "",
    url: url_IntegrationRuntimeNodesGetIpAddress_568500, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesRegenerateAuthKey_568511 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesRegenerateAuthKey_568513(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/regenerateAuthKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesRegenerateAuthKey_568512(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the authentication key for an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568514 = path.getOrDefault("resourceGroupName")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "resourceGroupName", valid_568514
  var valid_568515 = path.getOrDefault("factoryName")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "factoryName", valid_568515
  var valid_568516 = path.getOrDefault("integrationRuntimeName")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "integrationRuntimeName", valid_568516
  var valid_568517 = path.getOrDefault("subscriptionId")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "subscriptionId", valid_568517
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568518 = query.getOrDefault("api-version")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "api-version", valid_568518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regenerateKeyParameters: JObject (required)
  ##                          : The parameters for regenerating integration runtime authentication key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568520: Call_IntegrationRuntimesRegenerateAuthKey_568511;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the authentication key for an integration runtime.
  ## 
  let valid = call_568520.validator(path, query, header, formData, body)
  let scheme = call_568520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568520.url(scheme.get, call_568520.host, call_568520.base,
                         call_568520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568520, url, valid)

proc call*(call_568521: Call_IntegrationRuntimesRegenerateAuthKey_568511;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          regenerateKeyParameters: JsonNode; integrationRuntimeName: string;
          subscriptionId: string): Recallable =
  ## integrationRuntimesRegenerateAuthKey
  ## Regenerates the authentication key for an integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   regenerateKeyParameters: JObject (required)
  ##                          : The parameters for regenerating integration runtime authentication key.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568522 = newJObject()
  var query_568523 = newJObject()
  var body_568524 = newJObject()
  add(path_568522, "resourceGroupName", newJString(resourceGroupName))
  add(path_568522, "factoryName", newJString(factoryName))
  add(query_568523, "api-version", newJString(apiVersion))
  if regenerateKeyParameters != nil:
    body_568524 = regenerateKeyParameters
  add(path_568522, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568522, "subscriptionId", newJString(subscriptionId))
  result = call_568521.call(path_568522, query_568523, nil, nil, body_568524)

var integrationRuntimesRegenerateAuthKey* = Call_IntegrationRuntimesRegenerateAuthKey_568511(
    name: "integrationRuntimesRegenerateAuthKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/regenerateAuthKey",
    validator: validate_IntegrationRuntimesRegenerateAuthKey_568512, base: "",
    url: url_IntegrationRuntimesRegenerateAuthKey_568513, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesRemoveNode_568525 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesRemoveNode_568527(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/removeNode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesRemoveNode_568526(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove a node from integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568528 = path.getOrDefault("resourceGroupName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "resourceGroupName", valid_568528
  var valid_568529 = path.getOrDefault("factoryName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "factoryName", valid_568529
  var valid_568530 = path.getOrDefault("integrationRuntimeName")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "integrationRuntimeName", valid_568530
  var valid_568531 = path.getOrDefault("subscriptionId")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "subscriptionId", valid_568531
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568532 = query.getOrDefault("api-version")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "api-version", valid_568532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   removeNodeParameters: JObject (required)
  ##                       : The name of the node to be removed from an integration runtime.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568534: Call_IntegrationRuntimesRemoveNode_568525; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a node from integration runtime.
  ## 
  let valid = call_568534.validator(path, query, header, formData, body)
  let scheme = call_568534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568534.url(scheme.get, call_568534.host, call_568534.base,
                         call_568534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568534, url, valid)

proc call*(call_568535: Call_IntegrationRuntimesRemoveNode_568525;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          removeNodeParameters: JsonNode; integrationRuntimeName: string;
          subscriptionId: string): Recallable =
  ## integrationRuntimesRemoveNode
  ## Remove a node from integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   removeNodeParameters: JObject (required)
  ##                       : The name of the node to be removed from an integration runtime.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568536 = newJObject()
  var query_568537 = newJObject()
  var body_568538 = newJObject()
  add(path_568536, "resourceGroupName", newJString(resourceGroupName))
  add(path_568536, "factoryName", newJString(factoryName))
  add(query_568537, "api-version", newJString(apiVersion))
  if removeNodeParameters != nil:
    body_568538 = removeNodeParameters
  add(path_568536, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568536, "subscriptionId", newJString(subscriptionId))
  result = call_568535.call(path_568536, query_568537, nil, nil, body_568538)

var integrationRuntimesRemoveNode* = Call_IntegrationRuntimesRemoveNode_568525(
    name: "integrationRuntimesRemoveNode", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/removeNode",
    validator: validate_IntegrationRuntimesRemoveNode_568526, base: "",
    url: url_IntegrationRuntimesRemoveNode_568527, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesStart_568539 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesStart_568541(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesStart_568540(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a ManagedReserved type integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568542 = path.getOrDefault("resourceGroupName")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "resourceGroupName", valid_568542
  var valid_568543 = path.getOrDefault("factoryName")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "factoryName", valid_568543
  var valid_568544 = path.getOrDefault("integrationRuntimeName")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "integrationRuntimeName", valid_568544
  var valid_568545 = path.getOrDefault("subscriptionId")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "subscriptionId", valid_568545
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568546 = query.getOrDefault("api-version")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "api-version", valid_568546
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568547: Call_IntegrationRuntimesStart_568539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a ManagedReserved type integration runtime.
  ## 
  let valid = call_568547.validator(path, query, header, formData, body)
  let scheme = call_568547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568547.url(scheme.get, call_568547.host, call_568547.base,
                         call_568547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568547, url, valid)

proc call*(call_568548: Call_IntegrationRuntimesStart_568539;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesStart
  ## Starts a ManagedReserved type integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568549 = newJObject()
  var query_568550 = newJObject()
  add(path_568549, "resourceGroupName", newJString(resourceGroupName))
  add(path_568549, "factoryName", newJString(factoryName))
  add(query_568550, "api-version", newJString(apiVersion))
  add(path_568549, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568549, "subscriptionId", newJString(subscriptionId))
  result = call_568548.call(path_568549, query_568550, nil, nil, nil)

var integrationRuntimesStart* = Call_IntegrationRuntimesStart_568539(
    name: "integrationRuntimesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/start",
    validator: validate_IntegrationRuntimesStart_568540, base: "",
    url: url_IntegrationRuntimesStart_568541, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesStop_568551 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesStop_568553(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesStop_568552(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops a ManagedReserved type integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568554 = path.getOrDefault("resourceGroupName")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "resourceGroupName", valid_568554
  var valid_568555 = path.getOrDefault("factoryName")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "factoryName", valid_568555
  var valid_568556 = path.getOrDefault("integrationRuntimeName")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "integrationRuntimeName", valid_568556
  var valid_568557 = path.getOrDefault("subscriptionId")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "subscriptionId", valid_568557
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568558 = query.getOrDefault("api-version")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "api-version", valid_568558
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568559: Call_IntegrationRuntimesStop_568551; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a ManagedReserved type integration runtime.
  ## 
  let valid = call_568559.validator(path, query, header, formData, body)
  let scheme = call_568559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568559.url(scheme.get, call_568559.host, call_568559.base,
                         call_568559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568559, url, valid)

proc call*(call_568560: Call_IntegrationRuntimesStop_568551;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesStop
  ## Stops a ManagedReserved type integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568561 = newJObject()
  var query_568562 = newJObject()
  add(path_568561, "resourceGroupName", newJString(resourceGroupName))
  add(path_568561, "factoryName", newJString(factoryName))
  add(query_568562, "api-version", newJString(apiVersion))
  add(path_568561, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568561, "subscriptionId", newJString(subscriptionId))
  result = call_568560.call(path_568561, query_568562, nil, nil, nil)

var integrationRuntimesStop* = Call_IntegrationRuntimesStop_568551(
    name: "integrationRuntimesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/stop",
    validator: validate_IntegrationRuntimesStop_568552, base: "",
    url: url_IntegrationRuntimesStop_568553, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesSyncCredentials_568563 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesSyncCredentials_568565(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/syncCredentials")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesSyncCredentials_568564(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Force the integration runtime to synchronize credentials across integration runtime nodes, and this will override the credentials across all worker nodes with those available on the dispatcher node. If you already have the latest credential backup file, you should manually import it (preferred) on any self-hosted integration runtime node than using this API directly.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568566 = path.getOrDefault("resourceGroupName")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "resourceGroupName", valid_568566
  var valid_568567 = path.getOrDefault("factoryName")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "factoryName", valid_568567
  var valid_568568 = path.getOrDefault("integrationRuntimeName")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "integrationRuntimeName", valid_568568
  var valid_568569 = path.getOrDefault("subscriptionId")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "subscriptionId", valid_568569
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568570 = query.getOrDefault("api-version")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "api-version", valid_568570
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568571: Call_IntegrationRuntimesSyncCredentials_568563;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Force the integration runtime to synchronize credentials across integration runtime nodes, and this will override the credentials across all worker nodes with those available on the dispatcher node. If you already have the latest credential backup file, you should manually import it (preferred) on any self-hosted integration runtime node than using this API directly.
  ## 
  let valid = call_568571.validator(path, query, header, formData, body)
  let scheme = call_568571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568571.url(scheme.get, call_568571.host, call_568571.base,
                         call_568571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568571, url, valid)

proc call*(call_568572: Call_IntegrationRuntimesSyncCredentials_568563;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesSyncCredentials
  ## Force the integration runtime to synchronize credentials across integration runtime nodes, and this will override the credentials across all worker nodes with those available on the dispatcher node. If you already have the latest credential backup file, you should manually import it (preferred) on any self-hosted integration runtime node than using this API directly.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568573 = newJObject()
  var query_568574 = newJObject()
  add(path_568573, "resourceGroupName", newJString(resourceGroupName))
  add(path_568573, "factoryName", newJString(factoryName))
  add(query_568574, "api-version", newJString(apiVersion))
  add(path_568573, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568573, "subscriptionId", newJString(subscriptionId))
  result = call_568572.call(path_568573, query_568574, nil, nil, nil)

var integrationRuntimesSyncCredentials* = Call_IntegrationRuntimesSyncCredentials_568563(
    name: "integrationRuntimesSyncCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/syncCredentials",
    validator: validate_IntegrationRuntimesSyncCredentials_568564, base: "",
    url: url_IntegrationRuntimesSyncCredentials_568565, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesUpgrade_568575 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesUpgrade_568577(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/upgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesUpgrade_568576(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Upgrade self-hosted integration runtime to latest version if availability.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568578 = path.getOrDefault("resourceGroupName")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "resourceGroupName", valid_568578
  var valid_568579 = path.getOrDefault("factoryName")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "factoryName", valid_568579
  var valid_568580 = path.getOrDefault("integrationRuntimeName")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "integrationRuntimeName", valid_568580
  var valid_568581 = path.getOrDefault("subscriptionId")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "subscriptionId", valid_568581
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568582 = query.getOrDefault("api-version")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "api-version", valid_568582
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568583: Call_IntegrationRuntimesUpgrade_568575; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Upgrade self-hosted integration runtime to latest version if availability.
  ## 
  let valid = call_568583.validator(path, query, header, formData, body)
  let scheme = call_568583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568583.url(scheme.get, call_568583.host, call_568583.base,
                         call_568583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568583, url, valid)

proc call*(call_568584: Call_IntegrationRuntimesUpgrade_568575;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesUpgrade
  ## Upgrade self-hosted integration runtime to latest version if availability.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568585 = newJObject()
  var query_568586 = newJObject()
  add(path_568585, "resourceGroupName", newJString(resourceGroupName))
  add(path_568585, "factoryName", newJString(factoryName))
  add(query_568586, "api-version", newJString(apiVersion))
  add(path_568585, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568585, "subscriptionId", newJString(subscriptionId))
  result = call_568584.call(path_568585, query_568586, nil, nil, nil)

var integrationRuntimesUpgrade* = Call_IntegrationRuntimesUpgrade_568575(
    name: "integrationRuntimesUpgrade", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/upgrade",
    validator: validate_IntegrationRuntimesUpgrade_568576, base: "",
    url: url_IntegrationRuntimesUpgrade_568577, schemes: {Scheme.Https})
type
  Call_LinkedServicesListByFactory_568587 = ref object of OpenApiRestCall_567668
proc url_LinkedServicesListByFactory_568589(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/linkedservices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LinkedServicesListByFactory_568588(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists linked services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568590 = path.getOrDefault("resourceGroupName")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "resourceGroupName", valid_568590
  var valid_568591 = path.getOrDefault("factoryName")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "factoryName", valid_568591
  var valid_568592 = path.getOrDefault("subscriptionId")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "subscriptionId", valid_568592
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568593 = query.getOrDefault("api-version")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "api-version", valid_568593
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568594: Call_LinkedServicesListByFactory_568587; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists linked services.
  ## 
  let valid = call_568594.validator(path, query, header, formData, body)
  let scheme = call_568594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568594.url(scheme.get, call_568594.host, call_568594.base,
                         call_568594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568594, url, valid)

proc call*(call_568595: Call_LinkedServicesListByFactory_568587;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## linkedServicesListByFactory
  ## Lists linked services.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568596 = newJObject()
  var query_568597 = newJObject()
  add(path_568596, "resourceGroupName", newJString(resourceGroupName))
  add(path_568596, "factoryName", newJString(factoryName))
  add(query_568597, "api-version", newJString(apiVersion))
  add(path_568596, "subscriptionId", newJString(subscriptionId))
  result = call_568595.call(path_568596, query_568597, nil, nil, nil)

var linkedServicesListByFactory* = Call_LinkedServicesListByFactory_568587(
    name: "linkedServicesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices",
    validator: validate_LinkedServicesListByFactory_568588, base: "",
    url: url_LinkedServicesListByFactory_568589, schemes: {Scheme.Https})
type
  Call_LinkedServicesCreateOrUpdate_568610 = ref object of OpenApiRestCall_567668
proc url_LinkedServicesCreateOrUpdate_568612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "linkedServiceName" in path,
        "`linkedServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/linkedservices/"),
               (kind: VariableSegment, value: "linkedServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LinkedServicesCreateOrUpdate_568611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a linked service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   linkedServiceName: JString (required)
  ##                    : The linked service name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568613 = path.getOrDefault("resourceGroupName")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "resourceGroupName", valid_568613
  var valid_568614 = path.getOrDefault("factoryName")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "factoryName", valid_568614
  var valid_568615 = path.getOrDefault("linkedServiceName")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "linkedServiceName", valid_568615
  var valid_568616 = path.getOrDefault("subscriptionId")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "subscriptionId", valid_568616
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568617 = query.getOrDefault("api-version")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "api-version", valid_568617
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the linkedService entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_568618 = header.getOrDefault("If-Match")
  valid_568618 = validateParameter(valid_568618, JString, required = false,
                                 default = nil)
  if valid_568618 != nil:
    section.add "If-Match", valid_568618
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   linkedService: JObject (required)
  ##                : Linked service resource definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568620: Call_LinkedServicesCreateOrUpdate_568610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a linked service.
  ## 
  let valid = call_568620.validator(path, query, header, formData, body)
  let scheme = call_568620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568620.url(scheme.get, call_568620.host, call_568620.base,
                         call_568620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568620, url, valid)

proc call*(call_568621: Call_LinkedServicesCreateOrUpdate_568610;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          linkedServiceName: string; subscriptionId: string; linkedService: JsonNode): Recallable =
  ## linkedServicesCreateOrUpdate
  ## Creates or updates a linked service.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   linkedServiceName: string (required)
  ##                    : The linked service name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   linkedService: JObject (required)
  ##                : Linked service resource definition.
  var path_568622 = newJObject()
  var query_568623 = newJObject()
  var body_568624 = newJObject()
  add(path_568622, "resourceGroupName", newJString(resourceGroupName))
  add(path_568622, "factoryName", newJString(factoryName))
  add(query_568623, "api-version", newJString(apiVersion))
  add(path_568622, "linkedServiceName", newJString(linkedServiceName))
  add(path_568622, "subscriptionId", newJString(subscriptionId))
  if linkedService != nil:
    body_568624 = linkedService
  result = call_568621.call(path_568622, query_568623, nil, nil, body_568624)

var linkedServicesCreateOrUpdate* = Call_LinkedServicesCreateOrUpdate_568610(
    name: "linkedServicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesCreateOrUpdate_568611, base: "",
    url: url_LinkedServicesCreateOrUpdate_568612, schemes: {Scheme.Https})
type
  Call_LinkedServicesGet_568598 = ref object of OpenApiRestCall_567668
proc url_LinkedServicesGet_568600(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "linkedServiceName" in path,
        "`linkedServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/linkedservices/"),
               (kind: VariableSegment, value: "linkedServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LinkedServicesGet_568599(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a linked service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   linkedServiceName: JString (required)
  ##                    : The linked service name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568601 = path.getOrDefault("resourceGroupName")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "resourceGroupName", valid_568601
  var valid_568602 = path.getOrDefault("factoryName")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "factoryName", valid_568602
  var valid_568603 = path.getOrDefault("linkedServiceName")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "linkedServiceName", valid_568603
  var valid_568604 = path.getOrDefault("subscriptionId")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "subscriptionId", valid_568604
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568605 = query.getOrDefault("api-version")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "api-version", valid_568605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568606: Call_LinkedServicesGet_568598; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a linked service.
  ## 
  let valid = call_568606.validator(path, query, header, formData, body)
  let scheme = call_568606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568606.url(scheme.get, call_568606.host, call_568606.base,
                         call_568606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568606, url, valid)

proc call*(call_568607: Call_LinkedServicesGet_568598; resourceGroupName: string;
          factoryName: string; apiVersion: string; linkedServiceName: string;
          subscriptionId: string): Recallable =
  ## linkedServicesGet
  ## Gets a linked service.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   linkedServiceName: string (required)
  ##                    : The linked service name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568608 = newJObject()
  var query_568609 = newJObject()
  add(path_568608, "resourceGroupName", newJString(resourceGroupName))
  add(path_568608, "factoryName", newJString(factoryName))
  add(query_568609, "api-version", newJString(apiVersion))
  add(path_568608, "linkedServiceName", newJString(linkedServiceName))
  add(path_568608, "subscriptionId", newJString(subscriptionId))
  result = call_568607.call(path_568608, query_568609, nil, nil, nil)

var linkedServicesGet* = Call_LinkedServicesGet_568598(name: "linkedServicesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesGet_568599, base: "",
    url: url_LinkedServicesGet_568600, schemes: {Scheme.Https})
type
  Call_LinkedServicesDelete_568625 = ref object of OpenApiRestCall_567668
proc url_LinkedServicesDelete_568627(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "linkedServiceName" in path,
        "`linkedServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/linkedservices/"),
               (kind: VariableSegment, value: "linkedServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LinkedServicesDelete_568626(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a linked service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   linkedServiceName: JString (required)
  ##                    : The linked service name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568628 = path.getOrDefault("resourceGroupName")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "resourceGroupName", valid_568628
  var valid_568629 = path.getOrDefault("factoryName")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "factoryName", valid_568629
  var valid_568630 = path.getOrDefault("linkedServiceName")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "linkedServiceName", valid_568630
  var valid_568631 = path.getOrDefault("subscriptionId")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "subscriptionId", valid_568631
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568632 = query.getOrDefault("api-version")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "api-version", valid_568632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568633: Call_LinkedServicesDelete_568625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a linked service.
  ## 
  let valid = call_568633.validator(path, query, header, formData, body)
  let scheme = call_568633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568633.url(scheme.get, call_568633.host, call_568633.base,
                         call_568633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568633, url, valid)

proc call*(call_568634: Call_LinkedServicesDelete_568625;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          linkedServiceName: string; subscriptionId: string): Recallable =
  ## linkedServicesDelete
  ## Deletes a linked service.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   linkedServiceName: string (required)
  ##                    : The linked service name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568635 = newJObject()
  var query_568636 = newJObject()
  add(path_568635, "resourceGroupName", newJString(resourceGroupName))
  add(path_568635, "factoryName", newJString(factoryName))
  add(query_568636, "api-version", newJString(apiVersion))
  add(path_568635, "linkedServiceName", newJString(linkedServiceName))
  add(path_568635, "subscriptionId", newJString(subscriptionId))
  result = call_568634.call(path_568635, query_568636, nil, nil, nil)

var linkedServicesDelete* = Call_LinkedServicesDelete_568625(
    name: "linkedServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesDelete_568626, base: "",
    url: url_LinkedServicesDelete_568627, schemes: {Scheme.Https})
type
  Call_PipelineRunsQueryByFactory_568637 = ref object of OpenApiRestCall_567668
proc url_PipelineRunsQueryByFactory_568639(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelineruns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelineRunsQueryByFactory_568638(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query pipeline runs in the factory based on input filter conditions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568640 = path.getOrDefault("resourceGroupName")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "resourceGroupName", valid_568640
  var valid_568641 = path.getOrDefault("factoryName")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "factoryName", valid_568641
  var valid_568642 = path.getOrDefault("subscriptionId")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "subscriptionId", valid_568642
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568643 = query.getOrDefault("api-version")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "api-version", valid_568643
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   filterParameters: JObject (required)
  ##                   : Parameters to filter the pipeline run.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568645: Call_PipelineRunsQueryByFactory_568637; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query pipeline runs in the factory based on input filter conditions.
  ## 
  let valid = call_568645.validator(path, query, header, formData, body)
  let scheme = call_568645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568645.url(scheme.get, call_568645.host, call_568645.base,
                         call_568645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568645, url, valid)

proc call*(call_568646: Call_PipelineRunsQueryByFactory_568637;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; filterParameters: JsonNode): Recallable =
  ## pipelineRunsQueryByFactory
  ## Query pipeline runs in the factory based on input filter conditions.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   filterParameters: JObject (required)
  ##                   : Parameters to filter the pipeline run.
  var path_568647 = newJObject()
  var query_568648 = newJObject()
  var body_568649 = newJObject()
  add(path_568647, "resourceGroupName", newJString(resourceGroupName))
  add(path_568647, "factoryName", newJString(factoryName))
  add(query_568648, "api-version", newJString(apiVersion))
  add(path_568647, "subscriptionId", newJString(subscriptionId))
  if filterParameters != nil:
    body_568649 = filterParameters
  result = call_568646.call(path_568647, query_568648, nil, nil, body_568649)

var pipelineRunsQueryByFactory* = Call_PipelineRunsQueryByFactory_568637(
    name: "pipelineRunsQueryByFactory", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns",
    validator: validate_PipelineRunsQueryByFactory_568638, base: "",
    url: url_PipelineRunsQueryByFactory_568639, schemes: {Scheme.Https})
type
  Call_PipelineRunsGet_568650 = ref object of OpenApiRestCall_567668
proc url_PipelineRunsGet_568652(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelineruns/"),
               (kind: VariableSegment, value: "runId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelineRunsGet_568651(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get a pipeline run by its run ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   runId: JString (required)
  ##        : The pipeline run identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568653 = path.getOrDefault("resourceGroupName")
  valid_568653 = validateParameter(valid_568653, JString, required = true,
                                 default = nil)
  if valid_568653 != nil:
    section.add "resourceGroupName", valid_568653
  var valid_568654 = path.getOrDefault("factoryName")
  valid_568654 = validateParameter(valid_568654, JString, required = true,
                                 default = nil)
  if valid_568654 != nil:
    section.add "factoryName", valid_568654
  var valid_568655 = path.getOrDefault("subscriptionId")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "subscriptionId", valid_568655
  var valid_568656 = path.getOrDefault("runId")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "runId", valid_568656
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568657 = query.getOrDefault("api-version")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "api-version", valid_568657
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568658: Call_PipelineRunsGet_568650; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a pipeline run by its run ID.
  ## 
  let valid = call_568658.validator(path, query, header, formData, body)
  let scheme = call_568658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568658.url(scheme.get, call_568658.host, call_568658.base,
                         call_568658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568658, url, valid)

proc call*(call_568659: Call_PipelineRunsGet_568650; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          runId: string): Recallable =
  ## pipelineRunsGet
  ## Get a pipeline run by its run ID.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   runId: string (required)
  ##        : The pipeline run identifier.
  var path_568660 = newJObject()
  var query_568661 = newJObject()
  add(path_568660, "resourceGroupName", newJString(resourceGroupName))
  add(path_568660, "factoryName", newJString(factoryName))
  add(query_568661, "api-version", newJString(apiVersion))
  add(path_568660, "subscriptionId", newJString(subscriptionId))
  add(path_568660, "runId", newJString(runId))
  result = call_568659.call(path_568660, query_568661, nil, nil, nil)

var pipelineRunsGet* = Call_PipelineRunsGet_568650(name: "pipelineRunsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns/{runId}",
    validator: validate_PipelineRunsGet_568651, base: "", url: url_PipelineRunsGet_568652,
    schemes: {Scheme.Https})
type
  Call_ActivityRunsListByPipelineRun_568662 = ref object of OpenApiRestCall_567668
proc url_ActivityRunsListByPipelineRun_568664(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelineruns/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/activityruns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActivityRunsListByPipelineRun_568663(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List activity runs based on input filter conditions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   runId: JString (required)
  ##        : The pipeline run identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568665 = path.getOrDefault("resourceGroupName")
  valid_568665 = validateParameter(valid_568665, JString, required = true,
                                 default = nil)
  if valid_568665 != nil:
    section.add "resourceGroupName", valid_568665
  var valid_568666 = path.getOrDefault("factoryName")
  valid_568666 = validateParameter(valid_568666, JString, required = true,
                                 default = nil)
  if valid_568666 != nil:
    section.add "factoryName", valid_568666
  var valid_568667 = path.getOrDefault("subscriptionId")
  valid_568667 = validateParameter(valid_568667, JString, required = true,
                                 default = nil)
  if valid_568667 != nil:
    section.add "subscriptionId", valid_568667
  var valid_568668 = path.getOrDefault("runId")
  valid_568668 = validateParameter(valid_568668, JString, required = true,
                                 default = nil)
  if valid_568668 != nil:
    section.add "runId", valid_568668
  result.add "path", section
  ## parameters in `query` object:
  ##   linkedServiceName: JString
  ##                    : The linked service name.
  ##   api-version: JString (required)
  ##              : The API version.
  ##   endTime: JString (required)
  ##          : The end time of activity runs in ISO8601 format.
  ##   status: JString
  ##         : The status of the pipeline run.
  ##   startTime: JString (required)
  ##            : The start time of activity runs in ISO8601 format.
  ##   activityName: JString
  ##               : The name of the activity.
  section = newJObject()
  var valid_568669 = query.getOrDefault("linkedServiceName")
  valid_568669 = validateParameter(valid_568669, JString, required = false,
                                 default = nil)
  if valid_568669 != nil:
    section.add "linkedServiceName", valid_568669
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568670 = query.getOrDefault("api-version")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "api-version", valid_568670
  var valid_568671 = query.getOrDefault("endTime")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "endTime", valid_568671
  var valid_568672 = query.getOrDefault("status")
  valid_568672 = validateParameter(valid_568672, JString, required = false,
                                 default = nil)
  if valid_568672 != nil:
    section.add "status", valid_568672
  var valid_568673 = query.getOrDefault("startTime")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "startTime", valid_568673
  var valid_568674 = query.getOrDefault("activityName")
  valid_568674 = validateParameter(valid_568674, JString, required = false,
                                 default = nil)
  if valid_568674 != nil:
    section.add "activityName", valid_568674
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568675: Call_ActivityRunsListByPipelineRun_568662; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List activity runs based on input filter conditions.
  ## 
  let valid = call_568675.validator(path, query, header, formData, body)
  let scheme = call_568675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568675.url(scheme.get, call_568675.host, call_568675.base,
                         call_568675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568675, url, valid)

proc call*(call_568676: Call_ActivityRunsListByPipelineRun_568662;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; endTime: string; runId: string; startTime: string;
          linkedServiceName: string = ""; status: string = ""; activityName: string = ""): Recallable =
  ## activityRunsListByPipelineRun
  ## List activity runs based on input filter conditions.
  ##   linkedServiceName: string
  ##                    : The linked service name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   endTime: string (required)
  ##          : The end time of activity runs in ISO8601 format.
  ##   runId: string (required)
  ##        : The pipeline run identifier.
  ##   status: string
  ##         : The status of the pipeline run.
  ##   startTime: string (required)
  ##            : The start time of activity runs in ISO8601 format.
  ##   activityName: string
  ##               : The name of the activity.
  var path_568677 = newJObject()
  var query_568678 = newJObject()
  add(query_568678, "linkedServiceName", newJString(linkedServiceName))
  add(path_568677, "resourceGroupName", newJString(resourceGroupName))
  add(path_568677, "factoryName", newJString(factoryName))
  add(query_568678, "api-version", newJString(apiVersion))
  add(path_568677, "subscriptionId", newJString(subscriptionId))
  add(query_568678, "endTime", newJString(endTime))
  add(path_568677, "runId", newJString(runId))
  add(query_568678, "status", newJString(status))
  add(query_568678, "startTime", newJString(startTime))
  add(query_568678, "activityName", newJString(activityName))
  result = call_568676.call(path_568677, query_568678, nil, nil, nil)

var activityRunsListByPipelineRun* = Call_ActivityRunsListByPipelineRun_568662(
    name: "activityRunsListByPipelineRun", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns/{runId}/activityruns",
    validator: validate_ActivityRunsListByPipelineRun_568663, base: "",
    url: url_ActivityRunsListByPipelineRun_568664, schemes: {Scheme.Https})
type
  Call_PipelinesListByFactory_568679 = ref object of OpenApiRestCall_567668
proc url_PipelinesListByFactory_568681(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesListByFactory_568680(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists pipelines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568682 = path.getOrDefault("resourceGroupName")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "resourceGroupName", valid_568682
  var valid_568683 = path.getOrDefault("factoryName")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "factoryName", valid_568683
  var valid_568684 = path.getOrDefault("subscriptionId")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "subscriptionId", valid_568684
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568685 = query.getOrDefault("api-version")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "api-version", valid_568685
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568686: Call_PipelinesListByFactory_568679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists pipelines.
  ## 
  let valid = call_568686.validator(path, query, header, formData, body)
  let scheme = call_568686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568686.url(scheme.get, call_568686.host, call_568686.base,
                         call_568686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568686, url, valid)

proc call*(call_568687: Call_PipelinesListByFactory_568679;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## pipelinesListByFactory
  ## Lists pipelines.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568688 = newJObject()
  var query_568689 = newJObject()
  add(path_568688, "resourceGroupName", newJString(resourceGroupName))
  add(path_568688, "factoryName", newJString(factoryName))
  add(query_568689, "api-version", newJString(apiVersion))
  add(path_568688, "subscriptionId", newJString(subscriptionId))
  result = call_568687.call(path_568688, query_568689, nil, nil, nil)

var pipelinesListByFactory* = Call_PipelinesListByFactory_568679(
    name: "pipelinesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines",
    validator: validate_PipelinesListByFactory_568680, base: "",
    url: url_PipelinesListByFactory_568681, schemes: {Scheme.Https})
type
  Call_PipelinesCreateOrUpdate_568702 = ref object of OpenApiRestCall_567668
proc url_PipelinesCreateOrUpdate_568704(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "pipelineName" in path, "`pipelineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelines/"),
               (kind: VariableSegment, value: "pipelineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesCreateOrUpdate_568703(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   pipelineName: JString (required)
  ##               : The pipeline name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568705 = path.getOrDefault("resourceGroupName")
  valid_568705 = validateParameter(valid_568705, JString, required = true,
                                 default = nil)
  if valid_568705 != nil:
    section.add "resourceGroupName", valid_568705
  var valid_568706 = path.getOrDefault("factoryName")
  valid_568706 = validateParameter(valid_568706, JString, required = true,
                                 default = nil)
  if valid_568706 != nil:
    section.add "factoryName", valid_568706
  var valid_568707 = path.getOrDefault("subscriptionId")
  valid_568707 = validateParameter(valid_568707, JString, required = true,
                                 default = nil)
  if valid_568707 != nil:
    section.add "subscriptionId", valid_568707
  var valid_568708 = path.getOrDefault("pipelineName")
  valid_568708 = validateParameter(valid_568708, JString, required = true,
                                 default = nil)
  if valid_568708 != nil:
    section.add "pipelineName", valid_568708
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568709 = query.getOrDefault("api-version")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "api-version", valid_568709
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the pipeline entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_568710 = header.getOrDefault("If-Match")
  valid_568710 = validateParameter(valid_568710, JString, required = false,
                                 default = nil)
  if valid_568710 != nil:
    section.add "If-Match", valid_568710
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   pipeline: JObject (required)
  ##           : Pipeline resource definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568712: Call_PipelinesCreateOrUpdate_568702; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a pipeline.
  ## 
  let valid = call_568712.validator(path, query, header, formData, body)
  let scheme = call_568712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568712.url(scheme.get, call_568712.host, call_568712.base,
                         call_568712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568712, url, valid)

proc call*(call_568713: Call_PipelinesCreateOrUpdate_568702;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          pipeline: JsonNode; subscriptionId: string; pipelineName: string): Recallable =
  ## pipelinesCreateOrUpdate
  ## Creates or updates a pipeline.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   pipeline: JObject (required)
  ##           : Pipeline resource definition.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   pipelineName: string (required)
  ##               : The pipeline name.
  var path_568714 = newJObject()
  var query_568715 = newJObject()
  var body_568716 = newJObject()
  add(path_568714, "resourceGroupName", newJString(resourceGroupName))
  add(path_568714, "factoryName", newJString(factoryName))
  add(query_568715, "api-version", newJString(apiVersion))
  if pipeline != nil:
    body_568716 = pipeline
  add(path_568714, "subscriptionId", newJString(subscriptionId))
  add(path_568714, "pipelineName", newJString(pipelineName))
  result = call_568713.call(path_568714, query_568715, nil, nil, body_568716)

var pipelinesCreateOrUpdate* = Call_PipelinesCreateOrUpdate_568702(
    name: "pipelinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesCreateOrUpdate_568703, base: "",
    url: url_PipelinesCreateOrUpdate_568704, schemes: {Scheme.Https})
type
  Call_PipelinesGet_568690 = ref object of OpenApiRestCall_567668
proc url_PipelinesGet_568692(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "pipelineName" in path, "`pipelineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelines/"),
               (kind: VariableSegment, value: "pipelineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesGet_568691(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   pipelineName: JString (required)
  ##               : The pipeline name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568693 = path.getOrDefault("resourceGroupName")
  valid_568693 = validateParameter(valid_568693, JString, required = true,
                                 default = nil)
  if valid_568693 != nil:
    section.add "resourceGroupName", valid_568693
  var valid_568694 = path.getOrDefault("factoryName")
  valid_568694 = validateParameter(valid_568694, JString, required = true,
                                 default = nil)
  if valid_568694 != nil:
    section.add "factoryName", valid_568694
  var valid_568695 = path.getOrDefault("subscriptionId")
  valid_568695 = validateParameter(valid_568695, JString, required = true,
                                 default = nil)
  if valid_568695 != nil:
    section.add "subscriptionId", valid_568695
  var valid_568696 = path.getOrDefault("pipelineName")
  valid_568696 = validateParameter(valid_568696, JString, required = true,
                                 default = nil)
  if valid_568696 != nil:
    section.add "pipelineName", valid_568696
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568697 = query.getOrDefault("api-version")
  valid_568697 = validateParameter(valid_568697, JString, required = true,
                                 default = nil)
  if valid_568697 != nil:
    section.add "api-version", valid_568697
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568698: Call_PipelinesGet_568690; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a pipeline.
  ## 
  let valid = call_568698.validator(path, query, header, formData, body)
  let scheme = call_568698.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568698.url(scheme.get, call_568698.host, call_568698.base,
                         call_568698.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568698, url, valid)

proc call*(call_568699: Call_PipelinesGet_568690; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          pipelineName: string): Recallable =
  ## pipelinesGet
  ## Gets a pipeline.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   pipelineName: string (required)
  ##               : The pipeline name.
  var path_568700 = newJObject()
  var query_568701 = newJObject()
  add(path_568700, "resourceGroupName", newJString(resourceGroupName))
  add(path_568700, "factoryName", newJString(factoryName))
  add(query_568701, "api-version", newJString(apiVersion))
  add(path_568700, "subscriptionId", newJString(subscriptionId))
  add(path_568700, "pipelineName", newJString(pipelineName))
  result = call_568699.call(path_568700, query_568701, nil, nil, nil)

var pipelinesGet* = Call_PipelinesGet_568690(name: "pipelinesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesGet_568691, base: "", url: url_PipelinesGet_568692,
    schemes: {Scheme.Https})
type
  Call_PipelinesDelete_568717 = ref object of OpenApiRestCall_567668
proc url_PipelinesDelete_568719(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "pipelineName" in path, "`pipelineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelines/"),
               (kind: VariableSegment, value: "pipelineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesDelete_568718(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   pipelineName: JString (required)
  ##               : The pipeline name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568720 = path.getOrDefault("resourceGroupName")
  valid_568720 = validateParameter(valid_568720, JString, required = true,
                                 default = nil)
  if valid_568720 != nil:
    section.add "resourceGroupName", valid_568720
  var valid_568721 = path.getOrDefault("factoryName")
  valid_568721 = validateParameter(valid_568721, JString, required = true,
                                 default = nil)
  if valid_568721 != nil:
    section.add "factoryName", valid_568721
  var valid_568722 = path.getOrDefault("subscriptionId")
  valid_568722 = validateParameter(valid_568722, JString, required = true,
                                 default = nil)
  if valid_568722 != nil:
    section.add "subscriptionId", valid_568722
  var valid_568723 = path.getOrDefault("pipelineName")
  valid_568723 = validateParameter(valid_568723, JString, required = true,
                                 default = nil)
  if valid_568723 != nil:
    section.add "pipelineName", valid_568723
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568724 = query.getOrDefault("api-version")
  valid_568724 = validateParameter(valid_568724, JString, required = true,
                                 default = nil)
  if valid_568724 != nil:
    section.add "api-version", valid_568724
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568725: Call_PipelinesDelete_568717; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a pipeline.
  ## 
  let valid = call_568725.validator(path, query, header, formData, body)
  let scheme = call_568725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568725.url(scheme.get, call_568725.host, call_568725.base,
                         call_568725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568725, url, valid)

proc call*(call_568726: Call_PipelinesDelete_568717; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          pipelineName: string): Recallable =
  ## pipelinesDelete
  ## Deletes a pipeline.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   pipelineName: string (required)
  ##               : The pipeline name.
  var path_568727 = newJObject()
  var query_568728 = newJObject()
  add(path_568727, "resourceGroupName", newJString(resourceGroupName))
  add(path_568727, "factoryName", newJString(factoryName))
  add(query_568728, "api-version", newJString(apiVersion))
  add(path_568727, "subscriptionId", newJString(subscriptionId))
  add(path_568727, "pipelineName", newJString(pipelineName))
  result = call_568726.call(path_568727, query_568728, nil, nil, nil)

var pipelinesDelete* = Call_PipelinesDelete_568717(name: "pipelinesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesDelete_568718, base: "", url: url_PipelinesDelete_568719,
    schemes: {Scheme.Https})
type
  Call_PipelinesCreateRun_568729 = ref object of OpenApiRestCall_567668
proc url_PipelinesCreateRun_568731(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "pipelineName" in path, "`pipelineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelines/"),
               (kind: VariableSegment, value: "pipelineName"),
               (kind: ConstantSegment, value: "/createRun")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesCreateRun_568730(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a run of a pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   pipelineName: JString (required)
  ##               : The pipeline name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568732 = path.getOrDefault("resourceGroupName")
  valid_568732 = validateParameter(valid_568732, JString, required = true,
                                 default = nil)
  if valid_568732 != nil:
    section.add "resourceGroupName", valid_568732
  var valid_568733 = path.getOrDefault("factoryName")
  valid_568733 = validateParameter(valid_568733, JString, required = true,
                                 default = nil)
  if valid_568733 != nil:
    section.add "factoryName", valid_568733
  var valid_568734 = path.getOrDefault("subscriptionId")
  valid_568734 = validateParameter(valid_568734, JString, required = true,
                                 default = nil)
  if valid_568734 != nil:
    section.add "subscriptionId", valid_568734
  var valid_568735 = path.getOrDefault("pipelineName")
  valid_568735 = validateParameter(valid_568735, JString, required = true,
                                 default = nil)
  if valid_568735 != nil:
    section.add "pipelineName", valid_568735
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568736 = query.getOrDefault("api-version")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "api-version", valid_568736
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters of the pipeline run.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568738: Call_PipelinesCreateRun_568729; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a run of a pipeline.
  ## 
  let valid = call_568738.validator(path, query, header, formData, body)
  let scheme = call_568738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568738.url(scheme.get, call_568738.host, call_568738.base,
                         call_568738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568738, url, valid)

proc call*(call_568739: Call_PipelinesCreateRun_568729; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          pipelineName: string; parameters: JsonNode = nil): Recallable =
  ## pipelinesCreateRun
  ## Creates a run of a pipeline.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   pipelineName: string (required)
  ##               : The pipeline name.
  ##   parameters: JObject
  ##             : Parameters of the pipeline run.
  var path_568740 = newJObject()
  var query_568741 = newJObject()
  var body_568742 = newJObject()
  add(path_568740, "resourceGroupName", newJString(resourceGroupName))
  add(path_568740, "factoryName", newJString(factoryName))
  add(query_568741, "api-version", newJString(apiVersion))
  add(path_568740, "subscriptionId", newJString(subscriptionId))
  add(path_568740, "pipelineName", newJString(pipelineName))
  if parameters != nil:
    body_568742 = parameters
  result = call_568739.call(path_568740, query_568741, nil, nil, body_568742)

var pipelinesCreateRun* = Call_PipelinesCreateRun_568729(
    name: "pipelinesCreateRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}/createRun",
    validator: validate_PipelinesCreateRun_568730, base: "",
    url: url_PipelinesCreateRun_568731, schemes: {Scheme.Https})
type
  Call_TriggersListByFactory_568743 = ref object of OpenApiRestCall_567668
proc url_TriggersListByFactory_568745(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersListByFactory_568744(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists triggers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568746 = path.getOrDefault("resourceGroupName")
  valid_568746 = validateParameter(valid_568746, JString, required = true,
                                 default = nil)
  if valid_568746 != nil:
    section.add "resourceGroupName", valid_568746
  var valid_568747 = path.getOrDefault("factoryName")
  valid_568747 = validateParameter(valid_568747, JString, required = true,
                                 default = nil)
  if valid_568747 != nil:
    section.add "factoryName", valid_568747
  var valid_568748 = path.getOrDefault("subscriptionId")
  valid_568748 = validateParameter(valid_568748, JString, required = true,
                                 default = nil)
  if valid_568748 != nil:
    section.add "subscriptionId", valid_568748
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568749 = query.getOrDefault("api-version")
  valid_568749 = validateParameter(valid_568749, JString, required = true,
                                 default = nil)
  if valid_568749 != nil:
    section.add "api-version", valid_568749
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568750: Call_TriggersListByFactory_568743; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists triggers.
  ## 
  let valid = call_568750.validator(path, query, header, formData, body)
  let scheme = call_568750.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568750.url(scheme.get, call_568750.host, call_568750.base,
                         call_568750.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568750, url, valid)

proc call*(call_568751: Call_TriggersListByFactory_568743;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## triggersListByFactory
  ## Lists triggers.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568752 = newJObject()
  var query_568753 = newJObject()
  add(path_568752, "resourceGroupName", newJString(resourceGroupName))
  add(path_568752, "factoryName", newJString(factoryName))
  add(query_568753, "api-version", newJString(apiVersion))
  add(path_568752, "subscriptionId", newJString(subscriptionId))
  result = call_568751.call(path_568752, query_568753, nil, nil, nil)

var triggersListByFactory* = Call_TriggersListByFactory_568743(
    name: "triggersListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers",
    validator: validate_TriggersListByFactory_568744, base: "",
    url: url_TriggersListByFactory_568745, schemes: {Scheme.Https})
type
  Call_TriggersCreateOrUpdate_568766 = ref object of OpenApiRestCall_567668
proc url_TriggersCreateOrUpdate_568768(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersCreateOrUpdate_568767(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568769 = path.getOrDefault("resourceGroupName")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "resourceGroupName", valid_568769
  var valid_568770 = path.getOrDefault("factoryName")
  valid_568770 = validateParameter(valid_568770, JString, required = true,
                                 default = nil)
  if valid_568770 != nil:
    section.add "factoryName", valid_568770
  var valid_568771 = path.getOrDefault("subscriptionId")
  valid_568771 = validateParameter(valid_568771, JString, required = true,
                                 default = nil)
  if valid_568771 != nil:
    section.add "subscriptionId", valid_568771
  var valid_568772 = path.getOrDefault("triggerName")
  valid_568772 = validateParameter(valid_568772, JString, required = true,
                                 default = nil)
  if valid_568772 != nil:
    section.add "triggerName", valid_568772
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568773 = query.getOrDefault("api-version")
  valid_568773 = validateParameter(valid_568773, JString, required = true,
                                 default = nil)
  if valid_568773 != nil:
    section.add "api-version", valid_568773
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the trigger entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_568774 = header.getOrDefault("If-Match")
  valid_568774 = validateParameter(valid_568774, JString, required = false,
                                 default = nil)
  if valid_568774 != nil:
    section.add "If-Match", valid_568774
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   trigger: JObject (required)
  ##          : Trigger resource definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568776: Call_TriggersCreateOrUpdate_568766; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a trigger.
  ## 
  let valid = call_568776.validator(path, query, header, formData, body)
  let scheme = call_568776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568776.url(scheme.get, call_568776.host, call_568776.base,
                         call_568776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568776, url, valid)

proc call*(call_568777: Call_TriggersCreateOrUpdate_568766;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; trigger: JsonNode; triggerName: string): Recallable =
  ## triggersCreateOrUpdate
  ## Creates or updates a trigger.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   trigger: JObject (required)
  ##          : Trigger resource definition.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_568778 = newJObject()
  var query_568779 = newJObject()
  var body_568780 = newJObject()
  add(path_568778, "resourceGroupName", newJString(resourceGroupName))
  add(path_568778, "factoryName", newJString(factoryName))
  add(query_568779, "api-version", newJString(apiVersion))
  add(path_568778, "subscriptionId", newJString(subscriptionId))
  if trigger != nil:
    body_568780 = trigger
  add(path_568778, "triggerName", newJString(triggerName))
  result = call_568777.call(path_568778, query_568779, nil, nil, body_568780)

var triggersCreateOrUpdate* = Call_TriggersCreateOrUpdate_568766(
    name: "triggersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
    validator: validate_TriggersCreateOrUpdate_568767, base: "",
    url: url_TriggersCreateOrUpdate_568768, schemes: {Scheme.Https})
type
  Call_TriggersGet_568754 = ref object of OpenApiRestCall_567668
proc url_TriggersGet_568756(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersGet_568755(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568757 = path.getOrDefault("resourceGroupName")
  valid_568757 = validateParameter(valid_568757, JString, required = true,
                                 default = nil)
  if valid_568757 != nil:
    section.add "resourceGroupName", valid_568757
  var valid_568758 = path.getOrDefault("factoryName")
  valid_568758 = validateParameter(valid_568758, JString, required = true,
                                 default = nil)
  if valid_568758 != nil:
    section.add "factoryName", valid_568758
  var valid_568759 = path.getOrDefault("subscriptionId")
  valid_568759 = validateParameter(valid_568759, JString, required = true,
                                 default = nil)
  if valid_568759 != nil:
    section.add "subscriptionId", valid_568759
  var valid_568760 = path.getOrDefault("triggerName")
  valid_568760 = validateParameter(valid_568760, JString, required = true,
                                 default = nil)
  if valid_568760 != nil:
    section.add "triggerName", valid_568760
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568761 = query.getOrDefault("api-version")
  valid_568761 = validateParameter(valid_568761, JString, required = true,
                                 default = nil)
  if valid_568761 != nil:
    section.add "api-version", valid_568761
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568762: Call_TriggersGet_568754; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a trigger.
  ## 
  let valid = call_568762.validator(path, query, header, formData, body)
  let scheme = call_568762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568762.url(scheme.get, call_568762.host, call_568762.base,
                         call_568762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568762, url, valid)

proc call*(call_568763: Call_TriggersGet_568754; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          triggerName: string): Recallable =
  ## triggersGet
  ## Gets a trigger.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_568764 = newJObject()
  var query_568765 = newJObject()
  add(path_568764, "resourceGroupName", newJString(resourceGroupName))
  add(path_568764, "factoryName", newJString(factoryName))
  add(query_568765, "api-version", newJString(apiVersion))
  add(path_568764, "subscriptionId", newJString(subscriptionId))
  add(path_568764, "triggerName", newJString(triggerName))
  result = call_568763.call(path_568764, query_568765, nil, nil, nil)

var triggersGet* = Call_TriggersGet_568754(name: "triggersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
                                        validator: validate_TriggersGet_568755,
                                        base: "", url: url_TriggersGet_568756,
                                        schemes: {Scheme.Https})
type
  Call_TriggersDelete_568781 = ref object of OpenApiRestCall_567668
proc url_TriggersDelete_568783(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersDelete_568782(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568784 = path.getOrDefault("resourceGroupName")
  valid_568784 = validateParameter(valid_568784, JString, required = true,
                                 default = nil)
  if valid_568784 != nil:
    section.add "resourceGroupName", valid_568784
  var valid_568785 = path.getOrDefault("factoryName")
  valid_568785 = validateParameter(valid_568785, JString, required = true,
                                 default = nil)
  if valid_568785 != nil:
    section.add "factoryName", valid_568785
  var valid_568786 = path.getOrDefault("subscriptionId")
  valid_568786 = validateParameter(valid_568786, JString, required = true,
                                 default = nil)
  if valid_568786 != nil:
    section.add "subscriptionId", valid_568786
  var valid_568787 = path.getOrDefault("triggerName")
  valid_568787 = validateParameter(valid_568787, JString, required = true,
                                 default = nil)
  if valid_568787 != nil:
    section.add "triggerName", valid_568787
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568788 = query.getOrDefault("api-version")
  valid_568788 = validateParameter(valid_568788, JString, required = true,
                                 default = nil)
  if valid_568788 != nil:
    section.add "api-version", valid_568788
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568789: Call_TriggersDelete_568781; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a trigger.
  ## 
  let valid = call_568789.validator(path, query, header, formData, body)
  let scheme = call_568789.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568789.url(scheme.get, call_568789.host, call_568789.base,
                         call_568789.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568789, url, valid)

proc call*(call_568790: Call_TriggersDelete_568781; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          triggerName: string): Recallable =
  ## triggersDelete
  ## Deletes a trigger.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_568791 = newJObject()
  var query_568792 = newJObject()
  add(path_568791, "resourceGroupName", newJString(resourceGroupName))
  add(path_568791, "factoryName", newJString(factoryName))
  add(query_568792, "api-version", newJString(apiVersion))
  add(path_568791, "subscriptionId", newJString(subscriptionId))
  add(path_568791, "triggerName", newJString(triggerName))
  result = call_568790.call(path_568791, query_568792, nil, nil, nil)

var triggersDelete* = Call_TriggersDelete_568781(name: "triggersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
    validator: validate_TriggersDelete_568782, base: "", url: url_TriggersDelete_568783,
    schemes: {Scheme.Https})
type
  Call_TriggersStart_568793 = ref object of OpenApiRestCall_567668
proc url_TriggersStart_568795(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersStart_568794(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568796 = path.getOrDefault("resourceGroupName")
  valid_568796 = validateParameter(valid_568796, JString, required = true,
                                 default = nil)
  if valid_568796 != nil:
    section.add "resourceGroupName", valid_568796
  var valid_568797 = path.getOrDefault("factoryName")
  valid_568797 = validateParameter(valid_568797, JString, required = true,
                                 default = nil)
  if valid_568797 != nil:
    section.add "factoryName", valid_568797
  var valid_568798 = path.getOrDefault("subscriptionId")
  valid_568798 = validateParameter(valid_568798, JString, required = true,
                                 default = nil)
  if valid_568798 != nil:
    section.add "subscriptionId", valid_568798
  var valid_568799 = path.getOrDefault("triggerName")
  valid_568799 = validateParameter(valid_568799, JString, required = true,
                                 default = nil)
  if valid_568799 != nil:
    section.add "triggerName", valid_568799
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568800 = query.getOrDefault("api-version")
  valid_568800 = validateParameter(valid_568800, JString, required = true,
                                 default = nil)
  if valid_568800 != nil:
    section.add "api-version", valid_568800
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568801: Call_TriggersStart_568793; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a trigger.
  ## 
  let valid = call_568801.validator(path, query, header, formData, body)
  let scheme = call_568801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568801.url(scheme.get, call_568801.host, call_568801.base,
                         call_568801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568801, url, valid)

proc call*(call_568802: Call_TriggersStart_568793; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          triggerName: string): Recallable =
  ## triggersStart
  ## Starts a trigger.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_568803 = newJObject()
  var query_568804 = newJObject()
  add(path_568803, "resourceGroupName", newJString(resourceGroupName))
  add(path_568803, "factoryName", newJString(factoryName))
  add(query_568804, "api-version", newJString(apiVersion))
  add(path_568803, "subscriptionId", newJString(subscriptionId))
  add(path_568803, "triggerName", newJString(triggerName))
  result = call_568802.call(path_568803, query_568804, nil, nil, nil)

var triggersStart* = Call_TriggersStart_568793(name: "triggersStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/start",
    validator: validate_TriggersStart_568794, base: "", url: url_TriggersStart_568795,
    schemes: {Scheme.Https})
type
  Call_TriggersStop_568805 = ref object of OpenApiRestCall_567668
proc url_TriggersStop_568807(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersStop_568806(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568808 = path.getOrDefault("resourceGroupName")
  valid_568808 = validateParameter(valid_568808, JString, required = true,
                                 default = nil)
  if valid_568808 != nil:
    section.add "resourceGroupName", valid_568808
  var valid_568809 = path.getOrDefault("factoryName")
  valid_568809 = validateParameter(valid_568809, JString, required = true,
                                 default = nil)
  if valid_568809 != nil:
    section.add "factoryName", valid_568809
  var valid_568810 = path.getOrDefault("subscriptionId")
  valid_568810 = validateParameter(valid_568810, JString, required = true,
                                 default = nil)
  if valid_568810 != nil:
    section.add "subscriptionId", valid_568810
  var valid_568811 = path.getOrDefault("triggerName")
  valid_568811 = validateParameter(valid_568811, JString, required = true,
                                 default = nil)
  if valid_568811 != nil:
    section.add "triggerName", valid_568811
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568812 = query.getOrDefault("api-version")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = nil)
  if valid_568812 != nil:
    section.add "api-version", valid_568812
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568813: Call_TriggersStop_568805; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a trigger.
  ## 
  let valid = call_568813.validator(path, query, header, formData, body)
  let scheme = call_568813.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568813.url(scheme.get, call_568813.host, call_568813.base,
                         call_568813.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568813, url, valid)

proc call*(call_568814: Call_TriggersStop_568805; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          triggerName: string): Recallable =
  ## triggersStop
  ## Stops a trigger.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_568815 = newJObject()
  var query_568816 = newJObject()
  add(path_568815, "resourceGroupName", newJString(resourceGroupName))
  add(path_568815, "factoryName", newJString(factoryName))
  add(query_568816, "api-version", newJString(apiVersion))
  add(path_568815, "subscriptionId", newJString(subscriptionId))
  add(path_568815, "triggerName", newJString(triggerName))
  result = call_568814.call(path_568815, query_568816, nil, nil, nil)

var triggersStop* = Call_TriggersStop_568805(name: "triggersStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/stop",
    validator: validate_TriggersStop_568806, base: "", url: url_TriggersStop_568807,
    schemes: {Scheme.Https})
type
  Call_TriggersListRuns_568817 = ref object of OpenApiRestCall_567668
proc url_TriggersListRuns_568819(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/triggerruns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersListRuns_568818(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List trigger runs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568820 = path.getOrDefault("resourceGroupName")
  valid_568820 = validateParameter(valid_568820, JString, required = true,
                                 default = nil)
  if valid_568820 != nil:
    section.add "resourceGroupName", valid_568820
  var valid_568821 = path.getOrDefault("factoryName")
  valid_568821 = validateParameter(valid_568821, JString, required = true,
                                 default = nil)
  if valid_568821 != nil:
    section.add "factoryName", valid_568821
  var valid_568822 = path.getOrDefault("subscriptionId")
  valid_568822 = validateParameter(valid_568822, JString, required = true,
                                 default = nil)
  if valid_568822 != nil:
    section.add "subscriptionId", valid_568822
  var valid_568823 = path.getOrDefault("triggerName")
  valid_568823 = validateParameter(valid_568823, JString, required = true,
                                 default = nil)
  if valid_568823 != nil:
    section.add "triggerName", valid_568823
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   endTime: JString (required)
  ##          : End time for trigger runs.
  ##   startTime: JString (required)
  ##            : Start time for trigger runs.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568824 = query.getOrDefault("api-version")
  valid_568824 = validateParameter(valid_568824, JString, required = true,
                                 default = nil)
  if valid_568824 != nil:
    section.add "api-version", valid_568824
  var valid_568825 = query.getOrDefault("endTime")
  valid_568825 = validateParameter(valid_568825, JString, required = true,
                                 default = nil)
  if valid_568825 != nil:
    section.add "endTime", valid_568825
  var valid_568826 = query.getOrDefault("startTime")
  valid_568826 = validateParameter(valid_568826, JString, required = true,
                                 default = nil)
  if valid_568826 != nil:
    section.add "startTime", valid_568826
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568827: Call_TriggersListRuns_568817; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List trigger runs.
  ## 
  let valid = call_568827.validator(path, query, header, formData, body)
  let scheme = call_568827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568827.url(scheme.get, call_568827.host, call_568827.base,
                         call_568827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568827, url, valid)

proc call*(call_568828: Call_TriggersListRuns_568817; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          endTime: string; triggerName: string; startTime: string): Recallable =
  ## triggersListRuns
  ## List trigger runs.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   endTime: string (required)
  ##          : End time for trigger runs.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   startTime: string (required)
  ##            : Start time for trigger runs.
  var path_568829 = newJObject()
  var query_568830 = newJObject()
  add(path_568829, "resourceGroupName", newJString(resourceGroupName))
  add(path_568829, "factoryName", newJString(factoryName))
  add(query_568830, "api-version", newJString(apiVersion))
  add(path_568829, "subscriptionId", newJString(subscriptionId))
  add(query_568830, "endTime", newJString(endTime))
  add(path_568829, "triggerName", newJString(triggerName))
  add(query_568830, "startTime", newJString(startTime))
  result = call_568828.call(path_568829, query_568830, nil, nil, nil)

var triggersListRuns* = Call_TriggersListRuns_568817(name: "triggersListRuns",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/triggerruns",
    validator: validate_TriggersListRuns_568818, base: "",
    url: url_TriggersListRuns_568819, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
