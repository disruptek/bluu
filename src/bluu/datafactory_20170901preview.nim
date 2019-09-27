
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593439 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593439](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593439): Option[Scheme] {.used.} =
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
  macServiceName = "datafactory"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593661 = ref object of OpenApiRestCall_593439
proc url_OperationsList_593663(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593662(path: JsonNode; query: JsonNode;
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
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_OperationsList_593661; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available Azure Data Factory API operations.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_OperationsList_593661; apiVersion: string): Recallable =
  ## operationsList
  ## Lists the available Azure Data Factory API operations.
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_593917 = newJObject()
  add(query_593917, "api-version", newJString(apiVersion))
  result = call_593916.call(nil, query_593917, nil, nil, nil)

var operationsList* = Call_OperationsList_593661(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataFactory/operations",
    validator: validate_OperationsList_593662, base: "", url: url_OperationsList_593663,
    schemes: {Scheme.Https})
type
  Call_FactoriesList_593957 = ref object of OpenApiRestCall_593439
proc url_FactoriesList_593959(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesList_593958(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593974 = path.getOrDefault("subscriptionId")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "subscriptionId", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_593976: Call_FactoriesList_593957; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists factories under the specified subscription.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_FactoriesList_593957; apiVersion: string;
          subscriptionId: string): Recallable =
  ## factoriesList
  ## Lists factories under the specified subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_593978 = newJObject()
  var query_593979 = newJObject()
  add(query_593979, "api-version", newJString(apiVersion))
  add(path_593978, "subscriptionId", newJString(subscriptionId))
  result = call_593977.call(path_593978, query_593979, nil, nil, nil)

var factoriesList* = Call_FactoriesList_593957(name: "factoriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataFactory/factories",
    validator: validate_FactoriesList_593958, base: "", url: url_FactoriesList_593959,
    schemes: {Scheme.Https})
type
  Call_FactoriesConfigureFactoryRepo_593980 = ref object of OpenApiRestCall_593439
proc url_FactoriesConfigureFactoryRepo_593982(protocol: Scheme; host: string;
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

proc validate_FactoriesConfigureFactoryRepo_593981(path: JsonNode; query: JsonNode;
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
  var valid_594000 = path.getOrDefault("locationId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "locationId", valid_594000
  var valid_594001 = path.getOrDefault("subscriptionId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "subscriptionId", valid_594001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "api-version", valid_594002
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

proc call*(call_594004: Call_FactoriesConfigureFactoryRepo_593980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a factory's repo information.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_FactoriesConfigureFactoryRepo_593980;
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
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  var body_594008 = newJObject()
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "locationId", newJString(locationId))
  add(path_594006, "subscriptionId", newJString(subscriptionId))
  if factoryRepoUpdate != nil:
    body_594008 = factoryRepoUpdate
  result = call_594005.call(path_594006, query_594007, nil, nil, body_594008)

var factoriesConfigureFactoryRepo* = Call_FactoriesConfigureFactoryRepo_593980(
    name: "factoriesConfigureFactoryRepo", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataFactory/locations/{locationId}/configureFactoryRepo",
    validator: validate_FactoriesConfigureFactoryRepo_593981, base: "",
    url: url_FactoriesConfigureFactoryRepo_593982, schemes: {Scheme.Https})
type
  Call_FactoriesListByResourceGroup_594009 = ref object of OpenApiRestCall_593439
proc url_FactoriesListByResourceGroup_594011(protocol: Scheme; host: string;
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

proc validate_FactoriesListByResourceGroup_594010(path: JsonNode; query: JsonNode;
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
  var valid_594012 = path.getOrDefault("resourceGroupName")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "resourceGroupName", valid_594012
  var valid_594013 = path.getOrDefault("subscriptionId")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "subscriptionId", valid_594013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594014 = query.getOrDefault("api-version")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "api-version", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_FactoriesListByResourceGroup_594009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists factories.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_FactoriesListByResourceGroup_594009;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## factoriesListByResourceGroup
  ## Lists factories.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(path_594017, "resourceGroupName", newJString(resourceGroupName))
  add(query_594018, "api-version", newJString(apiVersion))
  add(path_594017, "subscriptionId", newJString(subscriptionId))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var factoriesListByResourceGroup* = Call_FactoriesListByResourceGroup_594009(
    name: "factoriesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories",
    validator: validate_FactoriesListByResourceGroup_594010, base: "",
    url: url_FactoriesListByResourceGroup_594011, schemes: {Scheme.Https})
type
  Call_FactoriesCreateOrUpdate_594030 = ref object of OpenApiRestCall_593439
proc url_FactoriesCreateOrUpdate_594032(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesCreateOrUpdate_594031(path: JsonNode; query: JsonNode;
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
  var valid_594033 = path.getOrDefault("resourceGroupName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "resourceGroupName", valid_594033
  var valid_594034 = path.getOrDefault("factoryName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "factoryName", valid_594034
  var valid_594035 = path.getOrDefault("subscriptionId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "subscriptionId", valid_594035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  ## parameters in `body` object:
  ##   factory: JObject (required)
  ##          : Factory resource definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594038: Call_FactoriesCreateOrUpdate_594030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a factory.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_FactoriesCreateOrUpdate_594030;
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
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  var body_594042 = newJObject()
  add(path_594040, "resourceGroupName", newJString(resourceGroupName))
  add(path_594040, "factoryName", newJString(factoryName))
  add(query_594041, "api-version", newJString(apiVersion))
  add(path_594040, "subscriptionId", newJString(subscriptionId))
  if factory != nil:
    body_594042 = factory
  result = call_594039.call(path_594040, query_594041, nil, nil, body_594042)

var factoriesCreateOrUpdate* = Call_FactoriesCreateOrUpdate_594030(
    name: "factoriesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesCreateOrUpdate_594031, base: "",
    url: url_FactoriesCreateOrUpdate_594032, schemes: {Scheme.Https})
type
  Call_FactoriesGet_594019 = ref object of OpenApiRestCall_593439
proc url_FactoriesGet_594021(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesGet_594020(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594022 = path.getOrDefault("resourceGroupName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "resourceGroupName", valid_594022
  var valid_594023 = path.getOrDefault("factoryName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "factoryName", valid_594023
  var valid_594024 = path.getOrDefault("subscriptionId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "subscriptionId", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_594026: Call_FactoriesGet_594019; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a factory.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_FactoriesGet_594019; resourceGroupName: string;
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
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(path_594028, "resourceGroupName", newJString(resourceGroupName))
  add(path_594028, "factoryName", newJString(factoryName))
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var factoriesGet* = Call_FactoriesGet_594019(name: "factoriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesGet_594020, base: "", url: url_FactoriesGet_594021,
    schemes: {Scheme.Https})
type
  Call_FactoriesUpdate_594054 = ref object of OpenApiRestCall_593439
proc url_FactoriesUpdate_594056(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesUpdate_594055(path: JsonNode; query: JsonNode;
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
  var valid_594057 = path.getOrDefault("resourceGroupName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "resourceGroupName", valid_594057
  var valid_594058 = path.getOrDefault("factoryName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "factoryName", valid_594058
  var valid_594059 = path.getOrDefault("subscriptionId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "subscriptionId", valid_594059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  ## parameters in `body` object:
  ##   factoryUpdateParameters: JObject (required)
  ##                          : The parameters for updating a factory.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594062: Call_FactoriesUpdate_594054; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a factory.
  ## 
  let valid = call_594062.validator(path, query, header, formData, body)
  let scheme = call_594062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594062.url(scheme.get, call_594062.host, call_594062.base,
                         call_594062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594062, url, valid)

proc call*(call_594063: Call_FactoriesUpdate_594054; resourceGroupName: string;
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
  var path_594064 = newJObject()
  var query_594065 = newJObject()
  var body_594066 = newJObject()
  add(path_594064, "resourceGroupName", newJString(resourceGroupName))
  add(path_594064, "factoryName", newJString(factoryName))
  add(query_594065, "api-version", newJString(apiVersion))
  add(path_594064, "subscriptionId", newJString(subscriptionId))
  if factoryUpdateParameters != nil:
    body_594066 = factoryUpdateParameters
  result = call_594063.call(path_594064, query_594065, nil, nil, body_594066)

var factoriesUpdate* = Call_FactoriesUpdate_594054(name: "factoriesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesUpdate_594055, base: "", url: url_FactoriesUpdate_594056,
    schemes: {Scheme.Https})
type
  Call_FactoriesDelete_594043 = ref object of OpenApiRestCall_593439
proc url_FactoriesDelete_594045(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesDelete_594044(path: JsonNode; query: JsonNode;
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
  var valid_594046 = path.getOrDefault("resourceGroupName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "resourceGroupName", valid_594046
  var valid_594047 = path.getOrDefault("factoryName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "factoryName", valid_594047
  var valid_594048 = path.getOrDefault("subscriptionId")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "subscriptionId", valid_594048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_594050: Call_FactoriesDelete_594043; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a factory.
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_FactoriesDelete_594043; resourceGroupName: string;
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
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  add(path_594052, "resourceGroupName", newJString(resourceGroupName))
  add(path_594052, "factoryName", newJString(factoryName))
  add(query_594053, "api-version", newJString(apiVersion))
  add(path_594052, "subscriptionId", newJString(subscriptionId))
  result = call_594051.call(path_594052, query_594053, nil, nil, nil)

var factoriesDelete* = Call_FactoriesDelete_594043(name: "factoriesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesDelete_594044, base: "", url: url_FactoriesDelete_594045,
    schemes: {Scheme.Https})
type
  Call_FactoriesCancelPipelineRun_594067 = ref object of OpenApiRestCall_593439
proc url_FactoriesCancelPipelineRun_594069(protocol: Scheme; host: string;
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

proc validate_FactoriesCancelPipelineRun_594068(path: JsonNode; query: JsonNode;
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
  var valid_594070 = path.getOrDefault("resourceGroupName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "resourceGroupName", valid_594070
  var valid_594071 = path.getOrDefault("factoryName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "factoryName", valid_594071
  var valid_594072 = path.getOrDefault("subscriptionId")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "subscriptionId", valid_594072
  var valid_594073 = path.getOrDefault("runId")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "runId", valid_594073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594074 = query.getOrDefault("api-version")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "api-version", valid_594074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594075: Call_FactoriesCancelPipelineRun_594067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a pipeline run by its run ID.
  ## 
  let valid = call_594075.validator(path, query, header, formData, body)
  let scheme = call_594075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594075.url(scheme.get, call_594075.host, call_594075.base,
                         call_594075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594075, url, valid)

proc call*(call_594076: Call_FactoriesCancelPipelineRun_594067;
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
  var path_594077 = newJObject()
  var query_594078 = newJObject()
  add(path_594077, "resourceGroupName", newJString(resourceGroupName))
  add(path_594077, "factoryName", newJString(factoryName))
  add(query_594078, "api-version", newJString(apiVersion))
  add(path_594077, "subscriptionId", newJString(subscriptionId))
  add(path_594077, "runId", newJString(runId))
  result = call_594076.call(path_594077, query_594078, nil, nil, nil)

var factoriesCancelPipelineRun* = Call_FactoriesCancelPipelineRun_594067(
    name: "factoriesCancelPipelineRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/cancelpipelinerun/{runId}",
    validator: validate_FactoriesCancelPipelineRun_594068, base: "",
    url: url_FactoriesCancelPipelineRun_594069, schemes: {Scheme.Https})
type
  Call_DatasetsListByFactory_594079 = ref object of OpenApiRestCall_593439
proc url_DatasetsListByFactory_594081(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsListByFactory_594080(path: JsonNode; query: JsonNode;
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
  var valid_594082 = path.getOrDefault("resourceGroupName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "resourceGroupName", valid_594082
  var valid_594083 = path.getOrDefault("factoryName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "factoryName", valid_594083
  var valid_594084 = path.getOrDefault("subscriptionId")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "subscriptionId", valid_594084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594085 = query.getOrDefault("api-version")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "api-version", valid_594085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594086: Call_DatasetsListByFactory_594079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists datasets.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_DatasetsListByFactory_594079;
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
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  add(path_594088, "resourceGroupName", newJString(resourceGroupName))
  add(path_594088, "factoryName", newJString(factoryName))
  add(query_594089, "api-version", newJString(apiVersion))
  add(path_594088, "subscriptionId", newJString(subscriptionId))
  result = call_594087.call(path_594088, query_594089, nil, nil, nil)

var datasetsListByFactory* = Call_DatasetsListByFactory_594079(
    name: "datasetsListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets",
    validator: validate_DatasetsListByFactory_594080, base: "",
    url: url_DatasetsListByFactory_594081, schemes: {Scheme.Https})
type
  Call_DatasetsCreateOrUpdate_594102 = ref object of OpenApiRestCall_593439
proc url_DatasetsCreateOrUpdate_594104(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsCreateOrUpdate_594103(path: JsonNode; query: JsonNode;
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
  var valid_594105 = path.getOrDefault("resourceGroupName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "resourceGroupName", valid_594105
  var valid_594106 = path.getOrDefault("factoryName")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "factoryName", valid_594106
  var valid_594107 = path.getOrDefault("subscriptionId")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "subscriptionId", valid_594107
  var valid_594108 = path.getOrDefault("datasetName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "datasetName", valid_594108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594109 = query.getOrDefault("api-version")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "api-version", valid_594109
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the dataset entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_594110 = header.getOrDefault("If-Match")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "If-Match", valid_594110
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

proc call*(call_594112: Call_DatasetsCreateOrUpdate_594102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a dataset.
  ## 
  let valid = call_594112.validator(path, query, header, formData, body)
  let scheme = call_594112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594112.url(scheme.get, call_594112.host, call_594112.base,
                         call_594112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594112, url, valid)

proc call*(call_594113: Call_DatasetsCreateOrUpdate_594102;
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
  var path_594114 = newJObject()
  var query_594115 = newJObject()
  var body_594116 = newJObject()
  add(path_594114, "resourceGroupName", newJString(resourceGroupName))
  add(path_594114, "factoryName", newJString(factoryName))
  add(query_594115, "api-version", newJString(apiVersion))
  add(path_594114, "subscriptionId", newJString(subscriptionId))
  add(path_594114, "datasetName", newJString(datasetName))
  if dataset != nil:
    body_594116 = dataset
  result = call_594113.call(path_594114, query_594115, nil, nil, body_594116)

var datasetsCreateOrUpdate* = Call_DatasetsCreateOrUpdate_594102(
    name: "datasetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
    validator: validate_DatasetsCreateOrUpdate_594103, base: "",
    url: url_DatasetsCreateOrUpdate_594104, schemes: {Scheme.Https})
type
  Call_DatasetsGet_594090 = ref object of OpenApiRestCall_593439
proc url_DatasetsGet_594092(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsGet_594091(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594093 = path.getOrDefault("resourceGroupName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "resourceGroupName", valid_594093
  var valid_594094 = path.getOrDefault("factoryName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "factoryName", valid_594094
  var valid_594095 = path.getOrDefault("subscriptionId")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "subscriptionId", valid_594095
  var valid_594096 = path.getOrDefault("datasetName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "datasetName", valid_594096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_594098: Call_DatasetsGet_594090; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a dataset.
  ## 
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_DatasetsGet_594090; resourceGroupName: string;
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
  var path_594100 = newJObject()
  var query_594101 = newJObject()
  add(path_594100, "resourceGroupName", newJString(resourceGroupName))
  add(path_594100, "factoryName", newJString(factoryName))
  add(query_594101, "api-version", newJString(apiVersion))
  add(path_594100, "subscriptionId", newJString(subscriptionId))
  add(path_594100, "datasetName", newJString(datasetName))
  result = call_594099.call(path_594100, query_594101, nil, nil, nil)

var datasetsGet* = Call_DatasetsGet_594090(name: "datasetsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
                                        validator: validate_DatasetsGet_594091,
                                        base: "", url: url_DatasetsGet_594092,
                                        schemes: {Scheme.Https})
type
  Call_DatasetsDelete_594117 = ref object of OpenApiRestCall_593439
proc url_DatasetsDelete_594119(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsDelete_594118(path: JsonNode; query: JsonNode;
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
  var valid_594120 = path.getOrDefault("resourceGroupName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "resourceGroupName", valid_594120
  var valid_594121 = path.getOrDefault("factoryName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "factoryName", valid_594121
  var valid_594122 = path.getOrDefault("subscriptionId")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "subscriptionId", valid_594122
  var valid_594123 = path.getOrDefault("datasetName")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "datasetName", valid_594123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594124 = query.getOrDefault("api-version")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "api-version", valid_594124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594125: Call_DatasetsDelete_594117; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a dataset.
  ## 
  let valid = call_594125.validator(path, query, header, formData, body)
  let scheme = call_594125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594125.url(scheme.get, call_594125.host, call_594125.base,
                         call_594125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594125, url, valid)

proc call*(call_594126: Call_DatasetsDelete_594117; resourceGroupName: string;
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
  var path_594127 = newJObject()
  var query_594128 = newJObject()
  add(path_594127, "resourceGroupName", newJString(resourceGroupName))
  add(path_594127, "factoryName", newJString(factoryName))
  add(query_594128, "api-version", newJString(apiVersion))
  add(path_594127, "subscriptionId", newJString(subscriptionId))
  add(path_594127, "datasetName", newJString(datasetName))
  result = call_594126.call(path_594127, query_594128, nil, nil, nil)

var datasetsDelete* = Call_DatasetsDelete_594117(name: "datasetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
    validator: validate_DatasetsDelete_594118, base: "", url: url_DatasetsDelete_594119,
    schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesListByFactory_594129 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesListByFactory_594131(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesListByFactory_594130(path: JsonNode;
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
  var valid_594132 = path.getOrDefault("resourceGroupName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "resourceGroupName", valid_594132
  var valid_594133 = path.getOrDefault("factoryName")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "factoryName", valid_594133
  var valid_594134 = path.getOrDefault("subscriptionId")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "subscriptionId", valid_594134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594135 = query.getOrDefault("api-version")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "api-version", valid_594135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594136: Call_IntegrationRuntimesListByFactory_594129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists integration runtimes.
  ## 
  let valid = call_594136.validator(path, query, header, formData, body)
  let scheme = call_594136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594136.url(scheme.get, call_594136.host, call_594136.base,
                         call_594136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594136, url, valid)

proc call*(call_594137: Call_IntegrationRuntimesListByFactory_594129;
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
  var path_594138 = newJObject()
  var query_594139 = newJObject()
  add(path_594138, "resourceGroupName", newJString(resourceGroupName))
  add(path_594138, "factoryName", newJString(factoryName))
  add(query_594139, "api-version", newJString(apiVersion))
  add(path_594138, "subscriptionId", newJString(subscriptionId))
  result = call_594137.call(path_594138, query_594139, nil, nil, nil)

var integrationRuntimesListByFactory* = Call_IntegrationRuntimesListByFactory_594129(
    name: "integrationRuntimesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes",
    validator: validate_IntegrationRuntimesListByFactory_594130, base: "",
    url: url_IntegrationRuntimesListByFactory_594131, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesCreateOrUpdate_594152 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesCreateOrUpdate_594154(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesCreateOrUpdate_594153(path: JsonNode;
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
  var valid_594155 = path.getOrDefault("resourceGroupName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "resourceGroupName", valid_594155
  var valid_594156 = path.getOrDefault("factoryName")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "factoryName", valid_594156
  var valid_594157 = path.getOrDefault("integrationRuntimeName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "integrationRuntimeName", valid_594157
  var valid_594158 = path.getOrDefault("subscriptionId")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "subscriptionId", valid_594158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594159 = query.getOrDefault("api-version")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "api-version", valid_594159
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the integration runtime entity. Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_594160 = header.getOrDefault("If-Match")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "If-Match", valid_594160
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

proc call*(call_594162: Call_IntegrationRuntimesCreateOrUpdate_594152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration runtime.
  ## 
  let valid = call_594162.validator(path, query, header, formData, body)
  let scheme = call_594162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594162.url(scheme.get, call_594162.host, call_594162.base,
                         call_594162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594162, url, valid)

proc call*(call_594163: Call_IntegrationRuntimesCreateOrUpdate_594152;
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
  var path_594164 = newJObject()
  var query_594165 = newJObject()
  var body_594166 = newJObject()
  add(path_594164, "resourceGroupName", newJString(resourceGroupName))
  add(path_594164, "factoryName", newJString(factoryName))
  add(query_594165, "api-version", newJString(apiVersion))
  add(path_594164, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594164, "subscriptionId", newJString(subscriptionId))
  if integrationRuntime != nil:
    body_594166 = integrationRuntime
  result = call_594163.call(path_594164, query_594165, nil, nil, body_594166)

var integrationRuntimesCreateOrUpdate* = Call_IntegrationRuntimesCreateOrUpdate_594152(
    name: "integrationRuntimesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesCreateOrUpdate_594153, base: "",
    url: url_IntegrationRuntimesCreateOrUpdate_594154, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGet_594140 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesGet_594142(protocol: Scheme; host: string; base: string;
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

proc validate_IntegrationRuntimesGet_594141(path: JsonNode; query: JsonNode;
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
  var valid_594143 = path.getOrDefault("resourceGroupName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "resourceGroupName", valid_594143
  var valid_594144 = path.getOrDefault("factoryName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "factoryName", valid_594144
  var valid_594145 = path.getOrDefault("integrationRuntimeName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "integrationRuntimeName", valid_594145
  var valid_594146 = path.getOrDefault("subscriptionId")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "subscriptionId", valid_594146
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594147 = query.getOrDefault("api-version")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "api-version", valid_594147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594148: Call_IntegrationRuntimesGet_594140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration runtime.
  ## 
  let valid = call_594148.validator(path, query, header, formData, body)
  let scheme = call_594148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594148.url(scheme.get, call_594148.host, call_594148.base,
                         call_594148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594148, url, valid)

proc call*(call_594149: Call_IntegrationRuntimesGet_594140;
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
  var path_594150 = newJObject()
  var query_594151 = newJObject()
  add(path_594150, "resourceGroupName", newJString(resourceGroupName))
  add(path_594150, "factoryName", newJString(factoryName))
  add(query_594151, "api-version", newJString(apiVersion))
  add(path_594150, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594150, "subscriptionId", newJString(subscriptionId))
  result = call_594149.call(path_594150, query_594151, nil, nil, nil)

var integrationRuntimesGet* = Call_IntegrationRuntimesGet_594140(
    name: "integrationRuntimesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesGet_594141, base: "",
    url: url_IntegrationRuntimesGet_594142, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesUpdate_594179 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesUpdate_594181(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesUpdate_594180(path: JsonNode; query: JsonNode;
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
  var valid_594182 = path.getOrDefault("resourceGroupName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "resourceGroupName", valid_594182
  var valid_594183 = path.getOrDefault("factoryName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "factoryName", valid_594183
  var valid_594184 = path.getOrDefault("integrationRuntimeName")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "integrationRuntimeName", valid_594184
  var valid_594185 = path.getOrDefault("subscriptionId")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "subscriptionId", valid_594185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594186 = query.getOrDefault("api-version")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "api-version", valid_594186
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

proc call*(call_594188: Call_IntegrationRuntimesUpdate_594179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an integration runtime.
  ## 
  let valid = call_594188.validator(path, query, header, formData, body)
  let scheme = call_594188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594188.url(scheme.get, call_594188.host, call_594188.base,
                         call_594188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594188, url, valid)

proc call*(call_594189: Call_IntegrationRuntimesUpdate_594179;
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
  var path_594190 = newJObject()
  var query_594191 = newJObject()
  var body_594192 = newJObject()
  add(path_594190, "resourceGroupName", newJString(resourceGroupName))
  add(path_594190, "factoryName", newJString(factoryName))
  add(query_594191, "api-version", newJString(apiVersion))
  add(path_594190, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594190, "subscriptionId", newJString(subscriptionId))
  if updateIntegrationRuntimeRequest != nil:
    body_594192 = updateIntegrationRuntimeRequest
  result = call_594189.call(path_594190, query_594191, nil, nil, body_594192)

var integrationRuntimesUpdate* = Call_IntegrationRuntimesUpdate_594179(
    name: "integrationRuntimesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesUpdate_594180, base: "",
    url: url_IntegrationRuntimesUpdate_594181, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesDelete_594167 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesDelete_594169(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesDelete_594168(path: JsonNode; query: JsonNode;
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
  var valid_594170 = path.getOrDefault("resourceGroupName")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "resourceGroupName", valid_594170
  var valid_594171 = path.getOrDefault("factoryName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "factoryName", valid_594171
  var valid_594172 = path.getOrDefault("integrationRuntimeName")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "integrationRuntimeName", valid_594172
  var valid_594173 = path.getOrDefault("subscriptionId")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "subscriptionId", valid_594173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594174 = query.getOrDefault("api-version")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "api-version", valid_594174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594175: Call_IntegrationRuntimesDelete_594167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration runtime.
  ## 
  let valid = call_594175.validator(path, query, header, formData, body)
  let scheme = call_594175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594175.url(scheme.get, call_594175.host, call_594175.base,
                         call_594175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594175, url, valid)

proc call*(call_594176: Call_IntegrationRuntimesDelete_594167;
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
  var path_594177 = newJObject()
  var query_594178 = newJObject()
  add(path_594177, "resourceGroupName", newJString(resourceGroupName))
  add(path_594177, "factoryName", newJString(factoryName))
  add(query_594178, "api-version", newJString(apiVersion))
  add(path_594177, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594177, "subscriptionId", newJString(subscriptionId))
  result = call_594176.call(path_594177, query_594178, nil, nil, nil)

var integrationRuntimesDelete* = Call_IntegrationRuntimesDelete_594167(
    name: "integrationRuntimesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesDelete_594168, base: "",
    url: url_IntegrationRuntimesDelete_594169, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetConnectionInfo_594193 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesGetConnectionInfo_594195(protocol: Scheme;
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

proc validate_IntegrationRuntimesGetConnectionInfo_594194(path: JsonNode;
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
  var valid_594196 = path.getOrDefault("resourceGroupName")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "resourceGroupName", valid_594196
  var valid_594197 = path.getOrDefault("factoryName")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "factoryName", valid_594197
  var valid_594198 = path.getOrDefault("integrationRuntimeName")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "integrationRuntimeName", valid_594198
  var valid_594199 = path.getOrDefault("subscriptionId")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "subscriptionId", valid_594199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594200 = query.getOrDefault("api-version")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "api-version", valid_594200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594201: Call_IntegrationRuntimesGetConnectionInfo_594193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the on-premises integration runtime connection information for encrypting the on-premises data source credentials.
  ## 
  let valid = call_594201.validator(path, query, header, formData, body)
  let scheme = call_594201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594201.url(scheme.get, call_594201.host, call_594201.base,
                         call_594201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594201, url, valid)

proc call*(call_594202: Call_IntegrationRuntimesGetConnectionInfo_594193;
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
  var path_594203 = newJObject()
  var query_594204 = newJObject()
  add(path_594203, "resourceGroupName", newJString(resourceGroupName))
  add(path_594203, "factoryName", newJString(factoryName))
  add(query_594204, "api-version", newJString(apiVersion))
  add(path_594203, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594203, "subscriptionId", newJString(subscriptionId))
  result = call_594202.call(path_594203, query_594204, nil, nil, nil)

var integrationRuntimesGetConnectionInfo* = Call_IntegrationRuntimesGetConnectionInfo_594193(
    name: "integrationRuntimesGetConnectionInfo", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/getConnectionInfo",
    validator: validate_IntegrationRuntimesGetConnectionInfo_594194, base: "",
    url: url_IntegrationRuntimesGetConnectionInfo_594195, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetStatus_594205 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesGetStatus_594207(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesGetStatus_594206(path: JsonNode; query: JsonNode;
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
  var valid_594208 = path.getOrDefault("resourceGroupName")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "resourceGroupName", valid_594208
  var valid_594209 = path.getOrDefault("factoryName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "factoryName", valid_594209
  var valid_594210 = path.getOrDefault("integrationRuntimeName")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "integrationRuntimeName", valid_594210
  var valid_594211 = path.getOrDefault("subscriptionId")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "subscriptionId", valid_594211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594212 = query.getOrDefault("api-version")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "api-version", valid_594212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594213: Call_IntegrationRuntimesGetStatus_594205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets detailed status information for an integration runtime.
  ## 
  let valid = call_594213.validator(path, query, header, formData, body)
  let scheme = call_594213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594213.url(scheme.get, call_594213.host, call_594213.base,
                         call_594213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594213, url, valid)

proc call*(call_594214: Call_IntegrationRuntimesGetStatus_594205;
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
  var path_594215 = newJObject()
  var query_594216 = newJObject()
  add(path_594215, "resourceGroupName", newJString(resourceGroupName))
  add(path_594215, "factoryName", newJString(factoryName))
  add(query_594216, "api-version", newJString(apiVersion))
  add(path_594215, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594215, "subscriptionId", newJString(subscriptionId))
  result = call_594214.call(path_594215, query_594216, nil, nil, nil)

var integrationRuntimesGetStatus* = Call_IntegrationRuntimesGetStatus_594205(
    name: "integrationRuntimesGetStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/getStatus",
    validator: validate_IntegrationRuntimesGetStatus_594206, base: "",
    url: url_IntegrationRuntimesGetStatus_594207, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesListAuthKeys_594217 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesListAuthKeys_594219(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesListAuthKeys_594218(path: JsonNode;
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
  var valid_594220 = path.getOrDefault("resourceGroupName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "resourceGroupName", valid_594220
  var valid_594221 = path.getOrDefault("factoryName")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "factoryName", valid_594221
  var valid_594222 = path.getOrDefault("integrationRuntimeName")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "integrationRuntimeName", valid_594222
  var valid_594223 = path.getOrDefault("subscriptionId")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "subscriptionId", valid_594223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594224 = query.getOrDefault("api-version")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "api-version", valid_594224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594225: Call_IntegrationRuntimesListAuthKeys_594217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the authentication keys for an integration runtime.
  ## 
  let valid = call_594225.validator(path, query, header, formData, body)
  let scheme = call_594225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594225.url(scheme.get, call_594225.host, call_594225.base,
                         call_594225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594225, url, valid)

proc call*(call_594226: Call_IntegrationRuntimesListAuthKeys_594217;
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
  var path_594227 = newJObject()
  var query_594228 = newJObject()
  add(path_594227, "resourceGroupName", newJString(resourceGroupName))
  add(path_594227, "factoryName", newJString(factoryName))
  add(query_594228, "api-version", newJString(apiVersion))
  add(path_594227, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594227, "subscriptionId", newJString(subscriptionId))
  result = call_594226.call(path_594227, query_594228, nil, nil, nil)

var integrationRuntimesListAuthKeys* = Call_IntegrationRuntimesListAuthKeys_594217(
    name: "integrationRuntimesListAuthKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/listAuthKeys",
    validator: validate_IntegrationRuntimesListAuthKeys_594218, base: "",
    url: url_IntegrationRuntimesListAuthKeys_594219, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetMonitoringData_594229 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesGetMonitoringData_594231(protocol: Scheme;
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

proc validate_IntegrationRuntimesGetMonitoringData_594230(path: JsonNode;
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
  var valid_594232 = path.getOrDefault("resourceGroupName")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "resourceGroupName", valid_594232
  var valid_594233 = path.getOrDefault("factoryName")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "factoryName", valid_594233
  var valid_594234 = path.getOrDefault("integrationRuntimeName")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "integrationRuntimeName", valid_594234
  var valid_594235 = path.getOrDefault("subscriptionId")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "subscriptionId", valid_594235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594236 = query.getOrDefault("api-version")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "api-version", valid_594236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594237: Call_IntegrationRuntimesGetMonitoringData_594229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the integration runtime monitoring data, which includes the monitor data for all the nodes under this integration runtime.
  ## 
  let valid = call_594237.validator(path, query, header, formData, body)
  let scheme = call_594237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594237.url(scheme.get, call_594237.host, call_594237.base,
                         call_594237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594237, url, valid)

proc call*(call_594238: Call_IntegrationRuntimesGetMonitoringData_594229;
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
  var path_594239 = newJObject()
  var query_594240 = newJObject()
  add(path_594239, "resourceGroupName", newJString(resourceGroupName))
  add(path_594239, "factoryName", newJString(factoryName))
  add(query_594240, "api-version", newJString(apiVersion))
  add(path_594239, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594239, "subscriptionId", newJString(subscriptionId))
  result = call_594238.call(path_594239, query_594240, nil, nil, nil)

var integrationRuntimesGetMonitoringData* = Call_IntegrationRuntimesGetMonitoringData_594229(
    name: "integrationRuntimesGetMonitoringData", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/monitoringData",
    validator: validate_IntegrationRuntimesGetMonitoringData_594230, base: "",
    url: url_IntegrationRuntimesGetMonitoringData_594231, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesUpdate_594254 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimeNodesUpdate_594256(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeNodesUpdate_594255(path: JsonNode; query: JsonNode;
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
  var valid_594257 = path.getOrDefault("resourceGroupName")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "resourceGroupName", valid_594257
  var valid_594258 = path.getOrDefault("factoryName")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "factoryName", valid_594258
  var valid_594259 = path.getOrDefault("nodeName")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "nodeName", valid_594259
  var valid_594260 = path.getOrDefault("integrationRuntimeName")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "integrationRuntimeName", valid_594260
  var valid_594261 = path.getOrDefault("subscriptionId")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "subscriptionId", valid_594261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594262 = query.getOrDefault("api-version")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "api-version", valid_594262
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

proc call*(call_594264: Call_IntegrationRuntimeNodesUpdate_594254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a self-hosted integration runtime node.
  ## 
  let valid = call_594264.validator(path, query, header, formData, body)
  let scheme = call_594264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594264.url(scheme.get, call_594264.host, call_594264.base,
                         call_594264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594264, url, valid)

proc call*(call_594265: Call_IntegrationRuntimeNodesUpdate_594254;
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
  var path_594266 = newJObject()
  var query_594267 = newJObject()
  var body_594268 = newJObject()
  add(path_594266, "resourceGroupName", newJString(resourceGroupName))
  add(path_594266, "factoryName", newJString(factoryName))
  add(query_594267, "api-version", newJString(apiVersion))
  add(path_594266, "nodeName", newJString(nodeName))
  add(path_594266, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594266, "subscriptionId", newJString(subscriptionId))
  if updateIntegrationRuntimeNodeRequest != nil:
    body_594268 = updateIntegrationRuntimeNodeRequest
  result = call_594265.call(path_594266, query_594267, nil, nil, body_594268)

var integrationRuntimeNodesUpdate* = Call_IntegrationRuntimeNodesUpdate_594254(
    name: "integrationRuntimeNodesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}",
    validator: validate_IntegrationRuntimeNodesUpdate_594255, base: "",
    url: url_IntegrationRuntimeNodesUpdate_594256, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesDelete_594241 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimeNodesDelete_594243(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeNodesDelete_594242(path: JsonNode; query: JsonNode;
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
  var valid_594244 = path.getOrDefault("resourceGroupName")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "resourceGroupName", valid_594244
  var valid_594245 = path.getOrDefault("factoryName")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "factoryName", valid_594245
  var valid_594246 = path.getOrDefault("nodeName")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "nodeName", valid_594246
  var valid_594247 = path.getOrDefault("integrationRuntimeName")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "integrationRuntimeName", valid_594247
  var valid_594248 = path.getOrDefault("subscriptionId")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "subscriptionId", valid_594248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594249 = query.getOrDefault("api-version")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "api-version", valid_594249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594250: Call_IntegrationRuntimeNodesDelete_594241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a self-hosted integration runtime node.
  ## 
  let valid = call_594250.validator(path, query, header, formData, body)
  let scheme = call_594250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594250.url(scheme.get, call_594250.host, call_594250.base,
                         call_594250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594250, url, valid)

proc call*(call_594251: Call_IntegrationRuntimeNodesDelete_594241;
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
  var path_594252 = newJObject()
  var query_594253 = newJObject()
  add(path_594252, "resourceGroupName", newJString(resourceGroupName))
  add(path_594252, "factoryName", newJString(factoryName))
  add(query_594253, "api-version", newJString(apiVersion))
  add(path_594252, "nodeName", newJString(nodeName))
  add(path_594252, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594252, "subscriptionId", newJString(subscriptionId))
  result = call_594251.call(path_594252, query_594253, nil, nil, nil)

var integrationRuntimeNodesDelete* = Call_IntegrationRuntimeNodesDelete_594241(
    name: "integrationRuntimeNodesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}",
    validator: validate_IntegrationRuntimeNodesDelete_594242, base: "",
    url: url_IntegrationRuntimeNodesDelete_594243, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesGetIpAddress_594269 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimeNodesGetIpAddress_594271(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeNodesGetIpAddress_594270(path: JsonNode;
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
  var valid_594272 = path.getOrDefault("resourceGroupName")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "resourceGroupName", valid_594272
  var valid_594273 = path.getOrDefault("factoryName")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "factoryName", valid_594273
  var valid_594274 = path.getOrDefault("nodeName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "nodeName", valid_594274
  var valid_594275 = path.getOrDefault("integrationRuntimeName")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "integrationRuntimeName", valid_594275
  var valid_594276 = path.getOrDefault("subscriptionId")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "subscriptionId", valid_594276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594277 = query.getOrDefault("api-version")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "api-version", valid_594277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594278: Call_IntegrationRuntimeNodesGetIpAddress_594269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IP address of self-hosted integration runtime node.
  ## 
  let valid = call_594278.validator(path, query, header, formData, body)
  let scheme = call_594278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594278.url(scheme.get, call_594278.host, call_594278.base,
                         call_594278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594278, url, valid)

proc call*(call_594279: Call_IntegrationRuntimeNodesGetIpAddress_594269;
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
  var path_594280 = newJObject()
  var query_594281 = newJObject()
  add(path_594280, "resourceGroupName", newJString(resourceGroupName))
  add(path_594280, "factoryName", newJString(factoryName))
  add(query_594281, "api-version", newJString(apiVersion))
  add(path_594280, "nodeName", newJString(nodeName))
  add(path_594280, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594280, "subscriptionId", newJString(subscriptionId))
  result = call_594279.call(path_594280, query_594281, nil, nil, nil)

var integrationRuntimeNodesGetIpAddress* = Call_IntegrationRuntimeNodesGetIpAddress_594269(
    name: "integrationRuntimeNodesGetIpAddress", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}/ipAddress",
    validator: validate_IntegrationRuntimeNodesGetIpAddress_594270, base: "",
    url: url_IntegrationRuntimeNodesGetIpAddress_594271, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesRegenerateAuthKey_594282 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesRegenerateAuthKey_594284(protocol: Scheme;
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

proc validate_IntegrationRuntimesRegenerateAuthKey_594283(path: JsonNode;
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
  var valid_594285 = path.getOrDefault("resourceGroupName")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "resourceGroupName", valid_594285
  var valid_594286 = path.getOrDefault("factoryName")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "factoryName", valid_594286
  var valid_594287 = path.getOrDefault("integrationRuntimeName")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "integrationRuntimeName", valid_594287
  var valid_594288 = path.getOrDefault("subscriptionId")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "subscriptionId", valid_594288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594289 = query.getOrDefault("api-version")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "api-version", valid_594289
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

proc call*(call_594291: Call_IntegrationRuntimesRegenerateAuthKey_594282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the authentication key for an integration runtime.
  ## 
  let valid = call_594291.validator(path, query, header, formData, body)
  let scheme = call_594291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594291.url(scheme.get, call_594291.host, call_594291.base,
                         call_594291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594291, url, valid)

proc call*(call_594292: Call_IntegrationRuntimesRegenerateAuthKey_594282;
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
  var path_594293 = newJObject()
  var query_594294 = newJObject()
  var body_594295 = newJObject()
  add(path_594293, "resourceGroupName", newJString(resourceGroupName))
  add(path_594293, "factoryName", newJString(factoryName))
  add(query_594294, "api-version", newJString(apiVersion))
  if regenerateKeyParameters != nil:
    body_594295 = regenerateKeyParameters
  add(path_594293, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594293, "subscriptionId", newJString(subscriptionId))
  result = call_594292.call(path_594293, query_594294, nil, nil, body_594295)

var integrationRuntimesRegenerateAuthKey* = Call_IntegrationRuntimesRegenerateAuthKey_594282(
    name: "integrationRuntimesRegenerateAuthKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/regenerateAuthKey",
    validator: validate_IntegrationRuntimesRegenerateAuthKey_594283, base: "",
    url: url_IntegrationRuntimesRegenerateAuthKey_594284, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesRemoveNode_594296 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesRemoveNode_594298(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesRemoveNode_594297(path: JsonNode; query: JsonNode;
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
  var valid_594299 = path.getOrDefault("resourceGroupName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "resourceGroupName", valid_594299
  var valid_594300 = path.getOrDefault("factoryName")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "factoryName", valid_594300
  var valid_594301 = path.getOrDefault("integrationRuntimeName")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "integrationRuntimeName", valid_594301
  var valid_594302 = path.getOrDefault("subscriptionId")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "subscriptionId", valid_594302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594303 = query.getOrDefault("api-version")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "api-version", valid_594303
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

proc call*(call_594305: Call_IntegrationRuntimesRemoveNode_594296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a node from integration runtime.
  ## 
  let valid = call_594305.validator(path, query, header, formData, body)
  let scheme = call_594305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594305.url(scheme.get, call_594305.host, call_594305.base,
                         call_594305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594305, url, valid)

proc call*(call_594306: Call_IntegrationRuntimesRemoveNode_594296;
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
  var path_594307 = newJObject()
  var query_594308 = newJObject()
  var body_594309 = newJObject()
  add(path_594307, "resourceGroupName", newJString(resourceGroupName))
  add(path_594307, "factoryName", newJString(factoryName))
  add(query_594308, "api-version", newJString(apiVersion))
  if removeNodeParameters != nil:
    body_594309 = removeNodeParameters
  add(path_594307, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594307, "subscriptionId", newJString(subscriptionId))
  result = call_594306.call(path_594307, query_594308, nil, nil, body_594309)

var integrationRuntimesRemoveNode* = Call_IntegrationRuntimesRemoveNode_594296(
    name: "integrationRuntimesRemoveNode", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/removeNode",
    validator: validate_IntegrationRuntimesRemoveNode_594297, base: "",
    url: url_IntegrationRuntimesRemoveNode_594298, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesStart_594310 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesStart_594312(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesStart_594311(path: JsonNode; query: JsonNode;
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
  var valid_594313 = path.getOrDefault("resourceGroupName")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "resourceGroupName", valid_594313
  var valid_594314 = path.getOrDefault("factoryName")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "factoryName", valid_594314
  var valid_594315 = path.getOrDefault("integrationRuntimeName")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "integrationRuntimeName", valid_594315
  var valid_594316 = path.getOrDefault("subscriptionId")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "subscriptionId", valid_594316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594317 = query.getOrDefault("api-version")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "api-version", valid_594317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594318: Call_IntegrationRuntimesStart_594310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a ManagedReserved type integration runtime.
  ## 
  let valid = call_594318.validator(path, query, header, formData, body)
  let scheme = call_594318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594318.url(scheme.get, call_594318.host, call_594318.base,
                         call_594318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594318, url, valid)

proc call*(call_594319: Call_IntegrationRuntimesStart_594310;
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
  var path_594320 = newJObject()
  var query_594321 = newJObject()
  add(path_594320, "resourceGroupName", newJString(resourceGroupName))
  add(path_594320, "factoryName", newJString(factoryName))
  add(query_594321, "api-version", newJString(apiVersion))
  add(path_594320, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594320, "subscriptionId", newJString(subscriptionId))
  result = call_594319.call(path_594320, query_594321, nil, nil, nil)

var integrationRuntimesStart* = Call_IntegrationRuntimesStart_594310(
    name: "integrationRuntimesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/start",
    validator: validate_IntegrationRuntimesStart_594311, base: "",
    url: url_IntegrationRuntimesStart_594312, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesStop_594322 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesStop_594324(protocol: Scheme; host: string; base: string;
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

proc validate_IntegrationRuntimesStop_594323(path: JsonNode; query: JsonNode;
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
  var valid_594325 = path.getOrDefault("resourceGroupName")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "resourceGroupName", valid_594325
  var valid_594326 = path.getOrDefault("factoryName")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "factoryName", valid_594326
  var valid_594327 = path.getOrDefault("integrationRuntimeName")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "integrationRuntimeName", valid_594327
  var valid_594328 = path.getOrDefault("subscriptionId")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "subscriptionId", valid_594328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594329 = query.getOrDefault("api-version")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "api-version", valid_594329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594330: Call_IntegrationRuntimesStop_594322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a ManagedReserved type integration runtime.
  ## 
  let valid = call_594330.validator(path, query, header, formData, body)
  let scheme = call_594330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594330.url(scheme.get, call_594330.host, call_594330.base,
                         call_594330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594330, url, valid)

proc call*(call_594331: Call_IntegrationRuntimesStop_594322;
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
  var path_594332 = newJObject()
  var query_594333 = newJObject()
  add(path_594332, "resourceGroupName", newJString(resourceGroupName))
  add(path_594332, "factoryName", newJString(factoryName))
  add(query_594333, "api-version", newJString(apiVersion))
  add(path_594332, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594332, "subscriptionId", newJString(subscriptionId))
  result = call_594331.call(path_594332, query_594333, nil, nil, nil)

var integrationRuntimesStop* = Call_IntegrationRuntimesStop_594322(
    name: "integrationRuntimesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/stop",
    validator: validate_IntegrationRuntimesStop_594323, base: "",
    url: url_IntegrationRuntimesStop_594324, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesSyncCredentials_594334 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesSyncCredentials_594336(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesSyncCredentials_594335(path: JsonNode;
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
  var valid_594337 = path.getOrDefault("resourceGroupName")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "resourceGroupName", valid_594337
  var valid_594338 = path.getOrDefault("factoryName")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "factoryName", valid_594338
  var valid_594339 = path.getOrDefault("integrationRuntimeName")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "integrationRuntimeName", valid_594339
  var valid_594340 = path.getOrDefault("subscriptionId")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "subscriptionId", valid_594340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594341 = query.getOrDefault("api-version")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "api-version", valid_594341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594342: Call_IntegrationRuntimesSyncCredentials_594334;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Force the integration runtime to synchronize credentials across integration runtime nodes, and this will override the credentials across all worker nodes with those available on the dispatcher node. If you already have the latest credential backup file, you should manually import it (preferred) on any self-hosted integration runtime node than using this API directly.
  ## 
  let valid = call_594342.validator(path, query, header, formData, body)
  let scheme = call_594342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594342.url(scheme.get, call_594342.host, call_594342.base,
                         call_594342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594342, url, valid)

proc call*(call_594343: Call_IntegrationRuntimesSyncCredentials_594334;
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
  var path_594344 = newJObject()
  var query_594345 = newJObject()
  add(path_594344, "resourceGroupName", newJString(resourceGroupName))
  add(path_594344, "factoryName", newJString(factoryName))
  add(query_594345, "api-version", newJString(apiVersion))
  add(path_594344, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594344, "subscriptionId", newJString(subscriptionId))
  result = call_594343.call(path_594344, query_594345, nil, nil, nil)

var integrationRuntimesSyncCredentials* = Call_IntegrationRuntimesSyncCredentials_594334(
    name: "integrationRuntimesSyncCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/syncCredentials",
    validator: validate_IntegrationRuntimesSyncCredentials_594335, base: "",
    url: url_IntegrationRuntimesSyncCredentials_594336, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesUpgrade_594346 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesUpgrade_594348(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesUpgrade_594347(path: JsonNode; query: JsonNode;
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
  var valid_594349 = path.getOrDefault("resourceGroupName")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "resourceGroupName", valid_594349
  var valid_594350 = path.getOrDefault("factoryName")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "factoryName", valid_594350
  var valid_594351 = path.getOrDefault("integrationRuntimeName")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "integrationRuntimeName", valid_594351
  var valid_594352 = path.getOrDefault("subscriptionId")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "subscriptionId", valid_594352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594353 = query.getOrDefault("api-version")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "api-version", valid_594353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594354: Call_IntegrationRuntimesUpgrade_594346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Upgrade self-hosted integration runtime to latest version if availability.
  ## 
  let valid = call_594354.validator(path, query, header, formData, body)
  let scheme = call_594354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594354.url(scheme.get, call_594354.host, call_594354.base,
                         call_594354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594354, url, valid)

proc call*(call_594355: Call_IntegrationRuntimesUpgrade_594346;
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
  var path_594356 = newJObject()
  var query_594357 = newJObject()
  add(path_594356, "resourceGroupName", newJString(resourceGroupName))
  add(path_594356, "factoryName", newJString(factoryName))
  add(query_594357, "api-version", newJString(apiVersion))
  add(path_594356, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594356, "subscriptionId", newJString(subscriptionId))
  result = call_594355.call(path_594356, query_594357, nil, nil, nil)

var integrationRuntimesUpgrade* = Call_IntegrationRuntimesUpgrade_594346(
    name: "integrationRuntimesUpgrade", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/upgrade",
    validator: validate_IntegrationRuntimesUpgrade_594347, base: "",
    url: url_IntegrationRuntimesUpgrade_594348, schemes: {Scheme.Https})
type
  Call_LinkedServicesListByFactory_594358 = ref object of OpenApiRestCall_593439
proc url_LinkedServicesListByFactory_594360(protocol: Scheme; host: string;
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

proc validate_LinkedServicesListByFactory_594359(path: JsonNode; query: JsonNode;
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
  var valid_594361 = path.getOrDefault("resourceGroupName")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "resourceGroupName", valid_594361
  var valid_594362 = path.getOrDefault("factoryName")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "factoryName", valid_594362
  var valid_594363 = path.getOrDefault("subscriptionId")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "subscriptionId", valid_594363
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594364 = query.getOrDefault("api-version")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "api-version", valid_594364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594365: Call_LinkedServicesListByFactory_594358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists linked services.
  ## 
  let valid = call_594365.validator(path, query, header, formData, body)
  let scheme = call_594365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594365.url(scheme.get, call_594365.host, call_594365.base,
                         call_594365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594365, url, valid)

proc call*(call_594366: Call_LinkedServicesListByFactory_594358;
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
  var path_594367 = newJObject()
  var query_594368 = newJObject()
  add(path_594367, "resourceGroupName", newJString(resourceGroupName))
  add(path_594367, "factoryName", newJString(factoryName))
  add(query_594368, "api-version", newJString(apiVersion))
  add(path_594367, "subscriptionId", newJString(subscriptionId))
  result = call_594366.call(path_594367, query_594368, nil, nil, nil)

var linkedServicesListByFactory* = Call_LinkedServicesListByFactory_594358(
    name: "linkedServicesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices",
    validator: validate_LinkedServicesListByFactory_594359, base: "",
    url: url_LinkedServicesListByFactory_594360, schemes: {Scheme.Https})
type
  Call_LinkedServicesCreateOrUpdate_594381 = ref object of OpenApiRestCall_593439
proc url_LinkedServicesCreateOrUpdate_594383(protocol: Scheme; host: string;
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

proc validate_LinkedServicesCreateOrUpdate_594382(path: JsonNode; query: JsonNode;
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
  var valid_594384 = path.getOrDefault("resourceGroupName")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = nil)
  if valid_594384 != nil:
    section.add "resourceGroupName", valid_594384
  var valid_594385 = path.getOrDefault("factoryName")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = nil)
  if valid_594385 != nil:
    section.add "factoryName", valid_594385
  var valid_594386 = path.getOrDefault("linkedServiceName")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "linkedServiceName", valid_594386
  var valid_594387 = path.getOrDefault("subscriptionId")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "subscriptionId", valid_594387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594388 = query.getOrDefault("api-version")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "api-version", valid_594388
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the linkedService entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_594389 = header.getOrDefault("If-Match")
  valid_594389 = validateParameter(valid_594389, JString, required = false,
                                 default = nil)
  if valid_594389 != nil:
    section.add "If-Match", valid_594389
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

proc call*(call_594391: Call_LinkedServicesCreateOrUpdate_594381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a linked service.
  ## 
  let valid = call_594391.validator(path, query, header, formData, body)
  let scheme = call_594391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594391.url(scheme.get, call_594391.host, call_594391.base,
                         call_594391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594391, url, valid)

proc call*(call_594392: Call_LinkedServicesCreateOrUpdate_594381;
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
  var path_594393 = newJObject()
  var query_594394 = newJObject()
  var body_594395 = newJObject()
  add(path_594393, "resourceGroupName", newJString(resourceGroupName))
  add(path_594393, "factoryName", newJString(factoryName))
  add(query_594394, "api-version", newJString(apiVersion))
  add(path_594393, "linkedServiceName", newJString(linkedServiceName))
  add(path_594393, "subscriptionId", newJString(subscriptionId))
  if linkedService != nil:
    body_594395 = linkedService
  result = call_594392.call(path_594393, query_594394, nil, nil, body_594395)

var linkedServicesCreateOrUpdate* = Call_LinkedServicesCreateOrUpdate_594381(
    name: "linkedServicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesCreateOrUpdate_594382, base: "",
    url: url_LinkedServicesCreateOrUpdate_594383, schemes: {Scheme.Https})
type
  Call_LinkedServicesGet_594369 = ref object of OpenApiRestCall_593439
proc url_LinkedServicesGet_594371(protocol: Scheme; host: string; base: string;
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

proc validate_LinkedServicesGet_594370(path: JsonNode; query: JsonNode;
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
  var valid_594372 = path.getOrDefault("resourceGroupName")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "resourceGroupName", valid_594372
  var valid_594373 = path.getOrDefault("factoryName")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "factoryName", valid_594373
  var valid_594374 = path.getOrDefault("linkedServiceName")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "linkedServiceName", valid_594374
  var valid_594375 = path.getOrDefault("subscriptionId")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "subscriptionId", valid_594375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594376 = query.getOrDefault("api-version")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "api-version", valid_594376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594377: Call_LinkedServicesGet_594369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a linked service.
  ## 
  let valid = call_594377.validator(path, query, header, formData, body)
  let scheme = call_594377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594377.url(scheme.get, call_594377.host, call_594377.base,
                         call_594377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594377, url, valid)

proc call*(call_594378: Call_LinkedServicesGet_594369; resourceGroupName: string;
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
  var path_594379 = newJObject()
  var query_594380 = newJObject()
  add(path_594379, "resourceGroupName", newJString(resourceGroupName))
  add(path_594379, "factoryName", newJString(factoryName))
  add(query_594380, "api-version", newJString(apiVersion))
  add(path_594379, "linkedServiceName", newJString(linkedServiceName))
  add(path_594379, "subscriptionId", newJString(subscriptionId))
  result = call_594378.call(path_594379, query_594380, nil, nil, nil)

var linkedServicesGet* = Call_LinkedServicesGet_594369(name: "linkedServicesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesGet_594370, base: "",
    url: url_LinkedServicesGet_594371, schemes: {Scheme.Https})
type
  Call_LinkedServicesDelete_594396 = ref object of OpenApiRestCall_593439
proc url_LinkedServicesDelete_594398(protocol: Scheme; host: string; base: string;
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

proc validate_LinkedServicesDelete_594397(path: JsonNode; query: JsonNode;
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
  var valid_594399 = path.getOrDefault("resourceGroupName")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "resourceGroupName", valid_594399
  var valid_594400 = path.getOrDefault("factoryName")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "factoryName", valid_594400
  var valid_594401 = path.getOrDefault("linkedServiceName")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "linkedServiceName", valid_594401
  var valid_594402 = path.getOrDefault("subscriptionId")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "subscriptionId", valid_594402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594403 = query.getOrDefault("api-version")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "api-version", valid_594403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594404: Call_LinkedServicesDelete_594396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a linked service.
  ## 
  let valid = call_594404.validator(path, query, header, formData, body)
  let scheme = call_594404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594404.url(scheme.get, call_594404.host, call_594404.base,
                         call_594404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594404, url, valid)

proc call*(call_594405: Call_LinkedServicesDelete_594396;
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
  var path_594406 = newJObject()
  var query_594407 = newJObject()
  add(path_594406, "resourceGroupName", newJString(resourceGroupName))
  add(path_594406, "factoryName", newJString(factoryName))
  add(query_594407, "api-version", newJString(apiVersion))
  add(path_594406, "linkedServiceName", newJString(linkedServiceName))
  add(path_594406, "subscriptionId", newJString(subscriptionId))
  result = call_594405.call(path_594406, query_594407, nil, nil, nil)

var linkedServicesDelete* = Call_LinkedServicesDelete_594396(
    name: "linkedServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesDelete_594397, base: "",
    url: url_LinkedServicesDelete_594398, schemes: {Scheme.Https})
type
  Call_PipelineRunsQueryByFactory_594408 = ref object of OpenApiRestCall_593439
proc url_PipelineRunsQueryByFactory_594410(protocol: Scheme; host: string;
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

proc validate_PipelineRunsQueryByFactory_594409(path: JsonNode; query: JsonNode;
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
  var valid_594411 = path.getOrDefault("resourceGroupName")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "resourceGroupName", valid_594411
  var valid_594412 = path.getOrDefault("factoryName")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "factoryName", valid_594412
  var valid_594413 = path.getOrDefault("subscriptionId")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "subscriptionId", valid_594413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594414 = query.getOrDefault("api-version")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "api-version", valid_594414
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

proc call*(call_594416: Call_PipelineRunsQueryByFactory_594408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query pipeline runs in the factory based on input filter conditions.
  ## 
  let valid = call_594416.validator(path, query, header, formData, body)
  let scheme = call_594416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594416.url(scheme.get, call_594416.host, call_594416.base,
                         call_594416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594416, url, valid)

proc call*(call_594417: Call_PipelineRunsQueryByFactory_594408;
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
  var path_594418 = newJObject()
  var query_594419 = newJObject()
  var body_594420 = newJObject()
  add(path_594418, "resourceGroupName", newJString(resourceGroupName))
  add(path_594418, "factoryName", newJString(factoryName))
  add(query_594419, "api-version", newJString(apiVersion))
  add(path_594418, "subscriptionId", newJString(subscriptionId))
  if filterParameters != nil:
    body_594420 = filterParameters
  result = call_594417.call(path_594418, query_594419, nil, nil, body_594420)

var pipelineRunsQueryByFactory* = Call_PipelineRunsQueryByFactory_594408(
    name: "pipelineRunsQueryByFactory", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns",
    validator: validate_PipelineRunsQueryByFactory_594409, base: "",
    url: url_PipelineRunsQueryByFactory_594410, schemes: {Scheme.Https})
type
  Call_PipelineRunsGet_594421 = ref object of OpenApiRestCall_593439
proc url_PipelineRunsGet_594423(protocol: Scheme; host: string; base: string;
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

proc validate_PipelineRunsGet_594422(path: JsonNode; query: JsonNode;
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
  var valid_594424 = path.getOrDefault("resourceGroupName")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "resourceGroupName", valid_594424
  var valid_594425 = path.getOrDefault("factoryName")
  valid_594425 = validateParameter(valid_594425, JString, required = true,
                                 default = nil)
  if valid_594425 != nil:
    section.add "factoryName", valid_594425
  var valid_594426 = path.getOrDefault("subscriptionId")
  valid_594426 = validateParameter(valid_594426, JString, required = true,
                                 default = nil)
  if valid_594426 != nil:
    section.add "subscriptionId", valid_594426
  var valid_594427 = path.getOrDefault("runId")
  valid_594427 = validateParameter(valid_594427, JString, required = true,
                                 default = nil)
  if valid_594427 != nil:
    section.add "runId", valid_594427
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594428 = query.getOrDefault("api-version")
  valid_594428 = validateParameter(valid_594428, JString, required = true,
                                 default = nil)
  if valid_594428 != nil:
    section.add "api-version", valid_594428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594429: Call_PipelineRunsGet_594421; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a pipeline run by its run ID.
  ## 
  let valid = call_594429.validator(path, query, header, formData, body)
  let scheme = call_594429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594429.url(scheme.get, call_594429.host, call_594429.base,
                         call_594429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594429, url, valid)

proc call*(call_594430: Call_PipelineRunsGet_594421; resourceGroupName: string;
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
  var path_594431 = newJObject()
  var query_594432 = newJObject()
  add(path_594431, "resourceGroupName", newJString(resourceGroupName))
  add(path_594431, "factoryName", newJString(factoryName))
  add(query_594432, "api-version", newJString(apiVersion))
  add(path_594431, "subscriptionId", newJString(subscriptionId))
  add(path_594431, "runId", newJString(runId))
  result = call_594430.call(path_594431, query_594432, nil, nil, nil)

var pipelineRunsGet* = Call_PipelineRunsGet_594421(name: "pipelineRunsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns/{runId}",
    validator: validate_PipelineRunsGet_594422, base: "", url: url_PipelineRunsGet_594423,
    schemes: {Scheme.Https})
type
  Call_ActivityRunsListByPipelineRun_594433 = ref object of OpenApiRestCall_593439
proc url_ActivityRunsListByPipelineRun_594435(protocol: Scheme; host: string;
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

proc validate_ActivityRunsListByPipelineRun_594434(path: JsonNode; query: JsonNode;
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
  var valid_594436 = path.getOrDefault("resourceGroupName")
  valid_594436 = validateParameter(valid_594436, JString, required = true,
                                 default = nil)
  if valid_594436 != nil:
    section.add "resourceGroupName", valid_594436
  var valid_594437 = path.getOrDefault("factoryName")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "factoryName", valid_594437
  var valid_594438 = path.getOrDefault("subscriptionId")
  valid_594438 = validateParameter(valid_594438, JString, required = true,
                                 default = nil)
  if valid_594438 != nil:
    section.add "subscriptionId", valid_594438
  var valid_594439 = path.getOrDefault("runId")
  valid_594439 = validateParameter(valid_594439, JString, required = true,
                                 default = nil)
  if valid_594439 != nil:
    section.add "runId", valid_594439
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
  var valid_594440 = query.getOrDefault("linkedServiceName")
  valid_594440 = validateParameter(valid_594440, JString, required = false,
                                 default = nil)
  if valid_594440 != nil:
    section.add "linkedServiceName", valid_594440
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594441 = query.getOrDefault("api-version")
  valid_594441 = validateParameter(valid_594441, JString, required = true,
                                 default = nil)
  if valid_594441 != nil:
    section.add "api-version", valid_594441
  var valid_594442 = query.getOrDefault("endTime")
  valid_594442 = validateParameter(valid_594442, JString, required = true,
                                 default = nil)
  if valid_594442 != nil:
    section.add "endTime", valid_594442
  var valid_594443 = query.getOrDefault("status")
  valid_594443 = validateParameter(valid_594443, JString, required = false,
                                 default = nil)
  if valid_594443 != nil:
    section.add "status", valid_594443
  var valid_594444 = query.getOrDefault("startTime")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = nil)
  if valid_594444 != nil:
    section.add "startTime", valid_594444
  var valid_594445 = query.getOrDefault("activityName")
  valid_594445 = validateParameter(valid_594445, JString, required = false,
                                 default = nil)
  if valid_594445 != nil:
    section.add "activityName", valid_594445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594446: Call_ActivityRunsListByPipelineRun_594433; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List activity runs based on input filter conditions.
  ## 
  let valid = call_594446.validator(path, query, header, formData, body)
  let scheme = call_594446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594446.url(scheme.get, call_594446.host, call_594446.base,
                         call_594446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594446, url, valid)

proc call*(call_594447: Call_ActivityRunsListByPipelineRun_594433;
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
  var path_594448 = newJObject()
  var query_594449 = newJObject()
  add(query_594449, "linkedServiceName", newJString(linkedServiceName))
  add(path_594448, "resourceGroupName", newJString(resourceGroupName))
  add(path_594448, "factoryName", newJString(factoryName))
  add(query_594449, "api-version", newJString(apiVersion))
  add(path_594448, "subscriptionId", newJString(subscriptionId))
  add(query_594449, "endTime", newJString(endTime))
  add(path_594448, "runId", newJString(runId))
  add(query_594449, "status", newJString(status))
  add(query_594449, "startTime", newJString(startTime))
  add(query_594449, "activityName", newJString(activityName))
  result = call_594447.call(path_594448, query_594449, nil, nil, nil)

var activityRunsListByPipelineRun* = Call_ActivityRunsListByPipelineRun_594433(
    name: "activityRunsListByPipelineRun", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns/{runId}/activityruns",
    validator: validate_ActivityRunsListByPipelineRun_594434, base: "",
    url: url_ActivityRunsListByPipelineRun_594435, schemes: {Scheme.Https})
type
  Call_PipelinesListByFactory_594450 = ref object of OpenApiRestCall_593439
proc url_PipelinesListByFactory_594452(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesListByFactory_594451(path: JsonNode; query: JsonNode;
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
  var valid_594453 = path.getOrDefault("resourceGroupName")
  valid_594453 = validateParameter(valid_594453, JString, required = true,
                                 default = nil)
  if valid_594453 != nil:
    section.add "resourceGroupName", valid_594453
  var valid_594454 = path.getOrDefault("factoryName")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "factoryName", valid_594454
  var valid_594455 = path.getOrDefault("subscriptionId")
  valid_594455 = validateParameter(valid_594455, JString, required = true,
                                 default = nil)
  if valid_594455 != nil:
    section.add "subscriptionId", valid_594455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594456 = query.getOrDefault("api-version")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "api-version", valid_594456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594457: Call_PipelinesListByFactory_594450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists pipelines.
  ## 
  let valid = call_594457.validator(path, query, header, formData, body)
  let scheme = call_594457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594457.url(scheme.get, call_594457.host, call_594457.base,
                         call_594457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594457, url, valid)

proc call*(call_594458: Call_PipelinesListByFactory_594450;
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
  var path_594459 = newJObject()
  var query_594460 = newJObject()
  add(path_594459, "resourceGroupName", newJString(resourceGroupName))
  add(path_594459, "factoryName", newJString(factoryName))
  add(query_594460, "api-version", newJString(apiVersion))
  add(path_594459, "subscriptionId", newJString(subscriptionId))
  result = call_594458.call(path_594459, query_594460, nil, nil, nil)

var pipelinesListByFactory* = Call_PipelinesListByFactory_594450(
    name: "pipelinesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines",
    validator: validate_PipelinesListByFactory_594451, base: "",
    url: url_PipelinesListByFactory_594452, schemes: {Scheme.Https})
type
  Call_PipelinesCreateOrUpdate_594473 = ref object of OpenApiRestCall_593439
proc url_PipelinesCreateOrUpdate_594475(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesCreateOrUpdate_594474(path: JsonNode; query: JsonNode;
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
  var valid_594476 = path.getOrDefault("resourceGroupName")
  valid_594476 = validateParameter(valid_594476, JString, required = true,
                                 default = nil)
  if valid_594476 != nil:
    section.add "resourceGroupName", valid_594476
  var valid_594477 = path.getOrDefault("factoryName")
  valid_594477 = validateParameter(valid_594477, JString, required = true,
                                 default = nil)
  if valid_594477 != nil:
    section.add "factoryName", valid_594477
  var valid_594478 = path.getOrDefault("subscriptionId")
  valid_594478 = validateParameter(valid_594478, JString, required = true,
                                 default = nil)
  if valid_594478 != nil:
    section.add "subscriptionId", valid_594478
  var valid_594479 = path.getOrDefault("pipelineName")
  valid_594479 = validateParameter(valid_594479, JString, required = true,
                                 default = nil)
  if valid_594479 != nil:
    section.add "pipelineName", valid_594479
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594480 = query.getOrDefault("api-version")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "api-version", valid_594480
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the pipeline entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_594481 = header.getOrDefault("If-Match")
  valid_594481 = validateParameter(valid_594481, JString, required = false,
                                 default = nil)
  if valid_594481 != nil:
    section.add "If-Match", valid_594481
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

proc call*(call_594483: Call_PipelinesCreateOrUpdate_594473; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a pipeline.
  ## 
  let valid = call_594483.validator(path, query, header, formData, body)
  let scheme = call_594483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594483.url(scheme.get, call_594483.host, call_594483.base,
                         call_594483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594483, url, valid)

proc call*(call_594484: Call_PipelinesCreateOrUpdate_594473;
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
  var path_594485 = newJObject()
  var query_594486 = newJObject()
  var body_594487 = newJObject()
  add(path_594485, "resourceGroupName", newJString(resourceGroupName))
  add(path_594485, "factoryName", newJString(factoryName))
  add(query_594486, "api-version", newJString(apiVersion))
  if pipeline != nil:
    body_594487 = pipeline
  add(path_594485, "subscriptionId", newJString(subscriptionId))
  add(path_594485, "pipelineName", newJString(pipelineName))
  result = call_594484.call(path_594485, query_594486, nil, nil, body_594487)

var pipelinesCreateOrUpdate* = Call_PipelinesCreateOrUpdate_594473(
    name: "pipelinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesCreateOrUpdate_594474, base: "",
    url: url_PipelinesCreateOrUpdate_594475, schemes: {Scheme.Https})
type
  Call_PipelinesGet_594461 = ref object of OpenApiRestCall_593439
proc url_PipelinesGet_594463(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesGet_594462(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594464 = path.getOrDefault("resourceGroupName")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "resourceGroupName", valid_594464
  var valid_594465 = path.getOrDefault("factoryName")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = nil)
  if valid_594465 != nil:
    section.add "factoryName", valid_594465
  var valid_594466 = path.getOrDefault("subscriptionId")
  valid_594466 = validateParameter(valid_594466, JString, required = true,
                                 default = nil)
  if valid_594466 != nil:
    section.add "subscriptionId", valid_594466
  var valid_594467 = path.getOrDefault("pipelineName")
  valid_594467 = validateParameter(valid_594467, JString, required = true,
                                 default = nil)
  if valid_594467 != nil:
    section.add "pipelineName", valid_594467
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594468 = query.getOrDefault("api-version")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = nil)
  if valid_594468 != nil:
    section.add "api-version", valid_594468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594469: Call_PipelinesGet_594461; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a pipeline.
  ## 
  let valid = call_594469.validator(path, query, header, formData, body)
  let scheme = call_594469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594469.url(scheme.get, call_594469.host, call_594469.base,
                         call_594469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594469, url, valid)

proc call*(call_594470: Call_PipelinesGet_594461; resourceGroupName: string;
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
  var path_594471 = newJObject()
  var query_594472 = newJObject()
  add(path_594471, "resourceGroupName", newJString(resourceGroupName))
  add(path_594471, "factoryName", newJString(factoryName))
  add(query_594472, "api-version", newJString(apiVersion))
  add(path_594471, "subscriptionId", newJString(subscriptionId))
  add(path_594471, "pipelineName", newJString(pipelineName))
  result = call_594470.call(path_594471, query_594472, nil, nil, nil)

var pipelinesGet* = Call_PipelinesGet_594461(name: "pipelinesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesGet_594462, base: "", url: url_PipelinesGet_594463,
    schemes: {Scheme.Https})
type
  Call_PipelinesDelete_594488 = ref object of OpenApiRestCall_593439
proc url_PipelinesDelete_594490(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesDelete_594489(path: JsonNode; query: JsonNode;
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
  var valid_594491 = path.getOrDefault("resourceGroupName")
  valid_594491 = validateParameter(valid_594491, JString, required = true,
                                 default = nil)
  if valid_594491 != nil:
    section.add "resourceGroupName", valid_594491
  var valid_594492 = path.getOrDefault("factoryName")
  valid_594492 = validateParameter(valid_594492, JString, required = true,
                                 default = nil)
  if valid_594492 != nil:
    section.add "factoryName", valid_594492
  var valid_594493 = path.getOrDefault("subscriptionId")
  valid_594493 = validateParameter(valid_594493, JString, required = true,
                                 default = nil)
  if valid_594493 != nil:
    section.add "subscriptionId", valid_594493
  var valid_594494 = path.getOrDefault("pipelineName")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "pipelineName", valid_594494
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594495 = query.getOrDefault("api-version")
  valid_594495 = validateParameter(valid_594495, JString, required = true,
                                 default = nil)
  if valid_594495 != nil:
    section.add "api-version", valid_594495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594496: Call_PipelinesDelete_594488; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a pipeline.
  ## 
  let valid = call_594496.validator(path, query, header, formData, body)
  let scheme = call_594496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594496.url(scheme.get, call_594496.host, call_594496.base,
                         call_594496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594496, url, valid)

proc call*(call_594497: Call_PipelinesDelete_594488; resourceGroupName: string;
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
  var path_594498 = newJObject()
  var query_594499 = newJObject()
  add(path_594498, "resourceGroupName", newJString(resourceGroupName))
  add(path_594498, "factoryName", newJString(factoryName))
  add(query_594499, "api-version", newJString(apiVersion))
  add(path_594498, "subscriptionId", newJString(subscriptionId))
  add(path_594498, "pipelineName", newJString(pipelineName))
  result = call_594497.call(path_594498, query_594499, nil, nil, nil)

var pipelinesDelete* = Call_PipelinesDelete_594488(name: "pipelinesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesDelete_594489, base: "", url: url_PipelinesDelete_594490,
    schemes: {Scheme.Https})
type
  Call_PipelinesCreateRun_594500 = ref object of OpenApiRestCall_593439
proc url_PipelinesCreateRun_594502(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesCreateRun_594501(path: JsonNode; query: JsonNode;
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
  var valid_594503 = path.getOrDefault("resourceGroupName")
  valid_594503 = validateParameter(valid_594503, JString, required = true,
                                 default = nil)
  if valid_594503 != nil:
    section.add "resourceGroupName", valid_594503
  var valid_594504 = path.getOrDefault("factoryName")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = nil)
  if valid_594504 != nil:
    section.add "factoryName", valid_594504
  var valid_594505 = path.getOrDefault("subscriptionId")
  valid_594505 = validateParameter(valid_594505, JString, required = true,
                                 default = nil)
  if valid_594505 != nil:
    section.add "subscriptionId", valid_594505
  var valid_594506 = path.getOrDefault("pipelineName")
  valid_594506 = validateParameter(valid_594506, JString, required = true,
                                 default = nil)
  if valid_594506 != nil:
    section.add "pipelineName", valid_594506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594507 = query.getOrDefault("api-version")
  valid_594507 = validateParameter(valid_594507, JString, required = true,
                                 default = nil)
  if valid_594507 != nil:
    section.add "api-version", valid_594507
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

proc call*(call_594509: Call_PipelinesCreateRun_594500; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a run of a pipeline.
  ## 
  let valid = call_594509.validator(path, query, header, formData, body)
  let scheme = call_594509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594509.url(scheme.get, call_594509.host, call_594509.base,
                         call_594509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594509, url, valid)

proc call*(call_594510: Call_PipelinesCreateRun_594500; resourceGroupName: string;
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
  var path_594511 = newJObject()
  var query_594512 = newJObject()
  var body_594513 = newJObject()
  add(path_594511, "resourceGroupName", newJString(resourceGroupName))
  add(path_594511, "factoryName", newJString(factoryName))
  add(query_594512, "api-version", newJString(apiVersion))
  add(path_594511, "subscriptionId", newJString(subscriptionId))
  add(path_594511, "pipelineName", newJString(pipelineName))
  if parameters != nil:
    body_594513 = parameters
  result = call_594510.call(path_594511, query_594512, nil, nil, body_594513)

var pipelinesCreateRun* = Call_PipelinesCreateRun_594500(
    name: "pipelinesCreateRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}/createRun",
    validator: validate_PipelinesCreateRun_594501, base: "",
    url: url_PipelinesCreateRun_594502, schemes: {Scheme.Https})
type
  Call_TriggersListByFactory_594514 = ref object of OpenApiRestCall_593439
proc url_TriggersListByFactory_594516(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersListByFactory_594515(path: JsonNode; query: JsonNode;
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
  var valid_594517 = path.getOrDefault("resourceGroupName")
  valid_594517 = validateParameter(valid_594517, JString, required = true,
                                 default = nil)
  if valid_594517 != nil:
    section.add "resourceGroupName", valid_594517
  var valid_594518 = path.getOrDefault("factoryName")
  valid_594518 = validateParameter(valid_594518, JString, required = true,
                                 default = nil)
  if valid_594518 != nil:
    section.add "factoryName", valid_594518
  var valid_594519 = path.getOrDefault("subscriptionId")
  valid_594519 = validateParameter(valid_594519, JString, required = true,
                                 default = nil)
  if valid_594519 != nil:
    section.add "subscriptionId", valid_594519
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594520 = query.getOrDefault("api-version")
  valid_594520 = validateParameter(valid_594520, JString, required = true,
                                 default = nil)
  if valid_594520 != nil:
    section.add "api-version", valid_594520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594521: Call_TriggersListByFactory_594514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists triggers.
  ## 
  let valid = call_594521.validator(path, query, header, formData, body)
  let scheme = call_594521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594521.url(scheme.get, call_594521.host, call_594521.base,
                         call_594521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594521, url, valid)

proc call*(call_594522: Call_TriggersListByFactory_594514;
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
  var path_594523 = newJObject()
  var query_594524 = newJObject()
  add(path_594523, "resourceGroupName", newJString(resourceGroupName))
  add(path_594523, "factoryName", newJString(factoryName))
  add(query_594524, "api-version", newJString(apiVersion))
  add(path_594523, "subscriptionId", newJString(subscriptionId))
  result = call_594522.call(path_594523, query_594524, nil, nil, nil)

var triggersListByFactory* = Call_TriggersListByFactory_594514(
    name: "triggersListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers",
    validator: validate_TriggersListByFactory_594515, base: "",
    url: url_TriggersListByFactory_594516, schemes: {Scheme.Https})
type
  Call_TriggersCreateOrUpdate_594537 = ref object of OpenApiRestCall_593439
proc url_TriggersCreateOrUpdate_594539(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersCreateOrUpdate_594538(path: JsonNode; query: JsonNode;
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
  var valid_594540 = path.getOrDefault("resourceGroupName")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "resourceGroupName", valid_594540
  var valid_594541 = path.getOrDefault("factoryName")
  valid_594541 = validateParameter(valid_594541, JString, required = true,
                                 default = nil)
  if valid_594541 != nil:
    section.add "factoryName", valid_594541
  var valid_594542 = path.getOrDefault("subscriptionId")
  valid_594542 = validateParameter(valid_594542, JString, required = true,
                                 default = nil)
  if valid_594542 != nil:
    section.add "subscriptionId", valid_594542
  var valid_594543 = path.getOrDefault("triggerName")
  valid_594543 = validateParameter(valid_594543, JString, required = true,
                                 default = nil)
  if valid_594543 != nil:
    section.add "triggerName", valid_594543
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594544 = query.getOrDefault("api-version")
  valid_594544 = validateParameter(valid_594544, JString, required = true,
                                 default = nil)
  if valid_594544 != nil:
    section.add "api-version", valid_594544
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the trigger entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_594545 = header.getOrDefault("If-Match")
  valid_594545 = validateParameter(valid_594545, JString, required = false,
                                 default = nil)
  if valid_594545 != nil:
    section.add "If-Match", valid_594545
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

proc call*(call_594547: Call_TriggersCreateOrUpdate_594537; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a trigger.
  ## 
  let valid = call_594547.validator(path, query, header, formData, body)
  let scheme = call_594547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594547.url(scheme.get, call_594547.host, call_594547.base,
                         call_594547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594547, url, valid)

proc call*(call_594548: Call_TriggersCreateOrUpdate_594537;
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
  var path_594549 = newJObject()
  var query_594550 = newJObject()
  var body_594551 = newJObject()
  add(path_594549, "resourceGroupName", newJString(resourceGroupName))
  add(path_594549, "factoryName", newJString(factoryName))
  add(query_594550, "api-version", newJString(apiVersion))
  add(path_594549, "subscriptionId", newJString(subscriptionId))
  if trigger != nil:
    body_594551 = trigger
  add(path_594549, "triggerName", newJString(triggerName))
  result = call_594548.call(path_594549, query_594550, nil, nil, body_594551)

var triggersCreateOrUpdate* = Call_TriggersCreateOrUpdate_594537(
    name: "triggersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
    validator: validate_TriggersCreateOrUpdate_594538, base: "",
    url: url_TriggersCreateOrUpdate_594539, schemes: {Scheme.Https})
type
  Call_TriggersGet_594525 = ref object of OpenApiRestCall_593439
proc url_TriggersGet_594527(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersGet_594526(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594528 = path.getOrDefault("resourceGroupName")
  valid_594528 = validateParameter(valid_594528, JString, required = true,
                                 default = nil)
  if valid_594528 != nil:
    section.add "resourceGroupName", valid_594528
  var valid_594529 = path.getOrDefault("factoryName")
  valid_594529 = validateParameter(valid_594529, JString, required = true,
                                 default = nil)
  if valid_594529 != nil:
    section.add "factoryName", valid_594529
  var valid_594530 = path.getOrDefault("subscriptionId")
  valid_594530 = validateParameter(valid_594530, JString, required = true,
                                 default = nil)
  if valid_594530 != nil:
    section.add "subscriptionId", valid_594530
  var valid_594531 = path.getOrDefault("triggerName")
  valid_594531 = validateParameter(valid_594531, JString, required = true,
                                 default = nil)
  if valid_594531 != nil:
    section.add "triggerName", valid_594531
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594532 = query.getOrDefault("api-version")
  valid_594532 = validateParameter(valid_594532, JString, required = true,
                                 default = nil)
  if valid_594532 != nil:
    section.add "api-version", valid_594532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594533: Call_TriggersGet_594525; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a trigger.
  ## 
  let valid = call_594533.validator(path, query, header, formData, body)
  let scheme = call_594533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594533.url(scheme.get, call_594533.host, call_594533.base,
                         call_594533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594533, url, valid)

proc call*(call_594534: Call_TriggersGet_594525; resourceGroupName: string;
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
  var path_594535 = newJObject()
  var query_594536 = newJObject()
  add(path_594535, "resourceGroupName", newJString(resourceGroupName))
  add(path_594535, "factoryName", newJString(factoryName))
  add(query_594536, "api-version", newJString(apiVersion))
  add(path_594535, "subscriptionId", newJString(subscriptionId))
  add(path_594535, "triggerName", newJString(triggerName))
  result = call_594534.call(path_594535, query_594536, nil, nil, nil)

var triggersGet* = Call_TriggersGet_594525(name: "triggersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
                                        validator: validate_TriggersGet_594526,
                                        base: "", url: url_TriggersGet_594527,
                                        schemes: {Scheme.Https})
type
  Call_TriggersDelete_594552 = ref object of OpenApiRestCall_593439
proc url_TriggersDelete_594554(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersDelete_594553(path: JsonNode; query: JsonNode;
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
  var valid_594555 = path.getOrDefault("resourceGroupName")
  valid_594555 = validateParameter(valid_594555, JString, required = true,
                                 default = nil)
  if valid_594555 != nil:
    section.add "resourceGroupName", valid_594555
  var valid_594556 = path.getOrDefault("factoryName")
  valid_594556 = validateParameter(valid_594556, JString, required = true,
                                 default = nil)
  if valid_594556 != nil:
    section.add "factoryName", valid_594556
  var valid_594557 = path.getOrDefault("subscriptionId")
  valid_594557 = validateParameter(valid_594557, JString, required = true,
                                 default = nil)
  if valid_594557 != nil:
    section.add "subscriptionId", valid_594557
  var valid_594558 = path.getOrDefault("triggerName")
  valid_594558 = validateParameter(valid_594558, JString, required = true,
                                 default = nil)
  if valid_594558 != nil:
    section.add "triggerName", valid_594558
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594559 = query.getOrDefault("api-version")
  valid_594559 = validateParameter(valid_594559, JString, required = true,
                                 default = nil)
  if valid_594559 != nil:
    section.add "api-version", valid_594559
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594560: Call_TriggersDelete_594552; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a trigger.
  ## 
  let valid = call_594560.validator(path, query, header, formData, body)
  let scheme = call_594560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594560.url(scheme.get, call_594560.host, call_594560.base,
                         call_594560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594560, url, valid)

proc call*(call_594561: Call_TriggersDelete_594552; resourceGroupName: string;
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
  var path_594562 = newJObject()
  var query_594563 = newJObject()
  add(path_594562, "resourceGroupName", newJString(resourceGroupName))
  add(path_594562, "factoryName", newJString(factoryName))
  add(query_594563, "api-version", newJString(apiVersion))
  add(path_594562, "subscriptionId", newJString(subscriptionId))
  add(path_594562, "triggerName", newJString(triggerName))
  result = call_594561.call(path_594562, query_594563, nil, nil, nil)

var triggersDelete* = Call_TriggersDelete_594552(name: "triggersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
    validator: validate_TriggersDelete_594553, base: "", url: url_TriggersDelete_594554,
    schemes: {Scheme.Https})
type
  Call_TriggersStart_594564 = ref object of OpenApiRestCall_593439
proc url_TriggersStart_594566(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersStart_594565(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594567 = path.getOrDefault("resourceGroupName")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = nil)
  if valid_594567 != nil:
    section.add "resourceGroupName", valid_594567
  var valid_594568 = path.getOrDefault("factoryName")
  valid_594568 = validateParameter(valid_594568, JString, required = true,
                                 default = nil)
  if valid_594568 != nil:
    section.add "factoryName", valid_594568
  var valid_594569 = path.getOrDefault("subscriptionId")
  valid_594569 = validateParameter(valid_594569, JString, required = true,
                                 default = nil)
  if valid_594569 != nil:
    section.add "subscriptionId", valid_594569
  var valid_594570 = path.getOrDefault("triggerName")
  valid_594570 = validateParameter(valid_594570, JString, required = true,
                                 default = nil)
  if valid_594570 != nil:
    section.add "triggerName", valid_594570
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594571 = query.getOrDefault("api-version")
  valid_594571 = validateParameter(valid_594571, JString, required = true,
                                 default = nil)
  if valid_594571 != nil:
    section.add "api-version", valid_594571
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594572: Call_TriggersStart_594564; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a trigger.
  ## 
  let valid = call_594572.validator(path, query, header, formData, body)
  let scheme = call_594572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594572.url(scheme.get, call_594572.host, call_594572.base,
                         call_594572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594572, url, valid)

proc call*(call_594573: Call_TriggersStart_594564; resourceGroupName: string;
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
  var path_594574 = newJObject()
  var query_594575 = newJObject()
  add(path_594574, "resourceGroupName", newJString(resourceGroupName))
  add(path_594574, "factoryName", newJString(factoryName))
  add(query_594575, "api-version", newJString(apiVersion))
  add(path_594574, "subscriptionId", newJString(subscriptionId))
  add(path_594574, "triggerName", newJString(triggerName))
  result = call_594573.call(path_594574, query_594575, nil, nil, nil)

var triggersStart* = Call_TriggersStart_594564(name: "triggersStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/start",
    validator: validate_TriggersStart_594565, base: "", url: url_TriggersStart_594566,
    schemes: {Scheme.Https})
type
  Call_TriggersStop_594576 = ref object of OpenApiRestCall_593439
proc url_TriggersStop_594578(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersStop_594577(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594579 = path.getOrDefault("resourceGroupName")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = nil)
  if valid_594579 != nil:
    section.add "resourceGroupName", valid_594579
  var valid_594580 = path.getOrDefault("factoryName")
  valid_594580 = validateParameter(valid_594580, JString, required = true,
                                 default = nil)
  if valid_594580 != nil:
    section.add "factoryName", valid_594580
  var valid_594581 = path.getOrDefault("subscriptionId")
  valid_594581 = validateParameter(valid_594581, JString, required = true,
                                 default = nil)
  if valid_594581 != nil:
    section.add "subscriptionId", valid_594581
  var valid_594582 = path.getOrDefault("triggerName")
  valid_594582 = validateParameter(valid_594582, JString, required = true,
                                 default = nil)
  if valid_594582 != nil:
    section.add "triggerName", valid_594582
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594583 = query.getOrDefault("api-version")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = nil)
  if valid_594583 != nil:
    section.add "api-version", valid_594583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594584: Call_TriggersStop_594576; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a trigger.
  ## 
  let valid = call_594584.validator(path, query, header, formData, body)
  let scheme = call_594584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594584.url(scheme.get, call_594584.host, call_594584.base,
                         call_594584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594584, url, valid)

proc call*(call_594585: Call_TriggersStop_594576; resourceGroupName: string;
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
  var path_594586 = newJObject()
  var query_594587 = newJObject()
  add(path_594586, "resourceGroupName", newJString(resourceGroupName))
  add(path_594586, "factoryName", newJString(factoryName))
  add(query_594587, "api-version", newJString(apiVersion))
  add(path_594586, "subscriptionId", newJString(subscriptionId))
  add(path_594586, "triggerName", newJString(triggerName))
  result = call_594585.call(path_594586, query_594587, nil, nil, nil)

var triggersStop* = Call_TriggersStop_594576(name: "triggersStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/stop",
    validator: validate_TriggersStop_594577, base: "", url: url_TriggersStop_594578,
    schemes: {Scheme.Https})
type
  Call_TriggersListRuns_594588 = ref object of OpenApiRestCall_593439
proc url_TriggersListRuns_594590(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersListRuns_594589(path: JsonNode; query: JsonNode;
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
  var valid_594591 = path.getOrDefault("resourceGroupName")
  valid_594591 = validateParameter(valid_594591, JString, required = true,
                                 default = nil)
  if valid_594591 != nil:
    section.add "resourceGroupName", valid_594591
  var valid_594592 = path.getOrDefault("factoryName")
  valid_594592 = validateParameter(valid_594592, JString, required = true,
                                 default = nil)
  if valid_594592 != nil:
    section.add "factoryName", valid_594592
  var valid_594593 = path.getOrDefault("subscriptionId")
  valid_594593 = validateParameter(valid_594593, JString, required = true,
                                 default = nil)
  if valid_594593 != nil:
    section.add "subscriptionId", valid_594593
  var valid_594594 = path.getOrDefault("triggerName")
  valid_594594 = validateParameter(valid_594594, JString, required = true,
                                 default = nil)
  if valid_594594 != nil:
    section.add "triggerName", valid_594594
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
  var valid_594595 = query.getOrDefault("api-version")
  valid_594595 = validateParameter(valid_594595, JString, required = true,
                                 default = nil)
  if valid_594595 != nil:
    section.add "api-version", valid_594595
  var valid_594596 = query.getOrDefault("endTime")
  valid_594596 = validateParameter(valid_594596, JString, required = true,
                                 default = nil)
  if valid_594596 != nil:
    section.add "endTime", valid_594596
  var valid_594597 = query.getOrDefault("startTime")
  valid_594597 = validateParameter(valid_594597, JString, required = true,
                                 default = nil)
  if valid_594597 != nil:
    section.add "startTime", valid_594597
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594598: Call_TriggersListRuns_594588; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List trigger runs.
  ## 
  let valid = call_594598.validator(path, query, header, formData, body)
  let scheme = call_594598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594598.url(scheme.get, call_594598.host, call_594598.base,
                         call_594598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594598, url, valid)

proc call*(call_594599: Call_TriggersListRuns_594588; resourceGroupName: string;
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
  var path_594600 = newJObject()
  var query_594601 = newJObject()
  add(path_594600, "resourceGroupName", newJString(resourceGroupName))
  add(path_594600, "factoryName", newJString(factoryName))
  add(query_594601, "api-version", newJString(apiVersion))
  add(path_594600, "subscriptionId", newJString(subscriptionId))
  add(query_594601, "endTime", newJString(endTime))
  add(path_594600, "triggerName", newJString(triggerName))
  add(query_594601, "startTime", newJString(startTime))
  result = call_594599.call(path_594600, query_594601, nil, nil, nil)

var triggersListRuns* = Call_TriggersListRuns_594588(name: "triggersListRuns",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/triggerruns",
    validator: validate_TriggersListRuns_594589, base: "",
    url: url_TriggersListRuns_594590, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
