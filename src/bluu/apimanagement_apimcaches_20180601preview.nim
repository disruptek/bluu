
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Cache entity in your Azure API Management deployment. Azure API Management also allows for caching responses in an external Azure Cache for Redis. For more information refer to [External Redis Cache in ApiManagement](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-cache-external).
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
  macServiceName = "apimanagement-apimcaches"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CacheListByService_593646 = ref object of OpenApiRestCall_593424
proc url_CacheListByService_593648(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/caches")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CacheListByService_593647(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists a collection of all external Caches in the specified service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593809 = path.getOrDefault("resourceGroupName")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "resourceGroupName", valid_593809
  var valid_593810 = path.getOrDefault("subscriptionId")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "subscriptionId", valid_593810
  var valid_593811 = path.getOrDefault("serviceName")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "serviceName", valid_593811
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593812 = query.getOrDefault("api-version")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "api-version", valid_593812
  var valid_593813 = query.getOrDefault("$top")
  valid_593813 = validateParameter(valid_593813, JInt, required = false, default = nil)
  if valid_593813 != nil:
    section.add "$top", valid_593813
  var valid_593814 = query.getOrDefault("$skip")
  valid_593814 = validateParameter(valid_593814, JInt, required = false, default = nil)
  if valid_593814 != nil:
    section.add "$skip", valid_593814
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593841: Call_CacheListByService_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of all external Caches in the specified service instance.
  ## 
  let valid = call_593841.validator(path, query, header, formData, body)
  let scheme = call_593841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593841.url(scheme.get, call_593841.host, call_593841.base,
                         call_593841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593841, url, valid)

proc call*(call_593912: Call_CacheListByService_593646; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Top: int = 0; Skip: int = 0): Recallable =
  ## cacheListByService
  ## Lists a collection of all external Caches in the specified service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_593913 = newJObject()
  var query_593915 = newJObject()
  add(path_593913, "resourceGroupName", newJString(resourceGroupName))
  add(query_593915, "api-version", newJString(apiVersion))
  add(path_593913, "subscriptionId", newJString(subscriptionId))
  add(query_593915, "$top", newJInt(Top))
  add(query_593915, "$skip", newJInt(Skip))
  add(path_593913, "serviceName", newJString(serviceName))
  result = call_593912.call(path_593913, query_593915, nil, nil, nil)

var cacheListByService* = Call_CacheListByService_593646(
    name: "cacheListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/caches",
    validator: validate_CacheListByService_593647, base: "",
    url: url_CacheListByService_593648, schemes: {Scheme.Https})
type
  Call_CacheCreateOrUpdate_593966 = ref object of OpenApiRestCall_593424
proc url_CacheCreateOrUpdate_593968(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "cacheId" in path, "`cacheId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/caches/"),
               (kind: VariableSegment, value: "cacheId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CacheCreateOrUpdate_593967(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates or updates an External Cache to be used in Api Management instance.
  ## 
  ## Use an external cache in Azure API Management
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-cache-external
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheId: JString (required)
  ##          : Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593996 = path.getOrDefault("resourceGroupName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "resourceGroupName", valid_593996
  var valid_593997 = path.getOrDefault("subscriptionId")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "subscriptionId", valid_593997
  var valid_593998 = path.getOrDefault("cacheId")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "cacheId", valid_593998
  var valid_593999 = path.getOrDefault("serviceName")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "serviceName", valid_593999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594000 = query.getOrDefault("api-version")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "api-version", valid_594000
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594001 = header.getOrDefault("If-Match")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "If-Match", valid_594001
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594003: Call_CacheCreateOrUpdate_593966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an External Cache to be used in Api Management instance.
  ## 
  ## Use an external cache in Azure API Management
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-cache-external
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_CacheCreateOrUpdate_593966; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; cacheId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## cacheCreateOrUpdate
  ## Creates or updates an External Cache to be used in Api Management instance.
  ## Use an external cache in Azure API Management
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-cache-external
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheId: string (required)
  ##          : Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).
  ##   parameters: JObject (required)
  ##             : Create or Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  var body_594007 = newJObject()
  add(path_594005, "resourceGroupName", newJString(resourceGroupName))
  add(query_594006, "api-version", newJString(apiVersion))
  add(path_594005, "subscriptionId", newJString(subscriptionId))
  add(path_594005, "cacheId", newJString(cacheId))
  if parameters != nil:
    body_594007 = parameters
  add(path_594005, "serviceName", newJString(serviceName))
  result = call_594004.call(path_594005, query_594006, nil, nil, body_594007)

var cacheCreateOrUpdate* = Call_CacheCreateOrUpdate_593966(
    name: "cacheCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/caches/{cacheId}",
    validator: validate_CacheCreateOrUpdate_593967, base: "",
    url: url_CacheCreateOrUpdate_593968, schemes: {Scheme.Https})
type
  Call_CacheGetEntityTag_594021 = ref object of OpenApiRestCall_593424
proc url_CacheGetEntityTag_594023(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "cacheId" in path, "`cacheId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/caches/"),
               (kind: VariableSegment, value: "cacheId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CacheGetEntityTag_594022(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the Cache specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheId: JString (required)
  ##          : Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594024 = path.getOrDefault("resourceGroupName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "resourceGroupName", valid_594024
  var valid_594025 = path.getOrDefault("subscriptionId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "subscriptionId", valid_594025
  var valid_594026 = path.getOrDefault("cacheId")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "cacheId", valid_594026
  var valid_594027 = path.getOrDefault("serviceName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "serviceName", valid_594027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594028 = query.getOrDefault("api-version")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "api-version", valid_594028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_CacheGetEntityTag_594021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the Cache specified by its identifier.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_CacheGetEntityTag_594021; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; cacheId: string;
          serviceName: string): Recallable =
  ## cacheGetEntityTag
  ## Gets the entity state (Etag) version of the Cache specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheId: string (required)
  ##          : Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  add(path_594031, "resourceGroupName", newJString(resourceGroupName))
  add(query_594032, "api-version", newJString(apiVersion))
  add(path_594031, "subscriptionId", newJString(subscriptionId))
  add(path_594031, "cacheId", newJString(cacheId))
  add(path_594031, "serviceName", newJString(serviceName))
  result = call_594030.call(path_594031, query_594032, nil, nil, nil)

var cacheGetEntityTag* = Call_CacheGetEntityTag_594021(name: "cacheGetEntityTag",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/caches/{cacheId}",
    validator: validate_CacheGetEntityTag_594022, base: "",
    url: url_CacheGetEntityTag_594023, schemes: {Scheme.Https})
type
  Call_CacheGet_593954 = ref object of OpenApiRestCall_593424
proc url_CacheGet_593956(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "cacheId" in path, "`cacheId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/caches/"),
               (kind: VariableSegment, value: "cacheId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CacheGet_593955(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the Cache specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheId: JString (required)
  ##          : Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593957 = path.getOrDefault("resourceGroupName")
  valid_593957 = validateParameter(valid_593957, JString, required = true,
                                 default = nil)
  if valid_593957 != nil:
    section.add "resourceGroupName", valid_593957
  var valid_593958 = path.getOrDefault("subscriptionId")
  valid_593958 = validateParameter(valid_593958, JString, required = true,
                                 default = nil)
  if valid_593958 != nil:
    section.add "subscriptionId", valid_593958
  var valid_593959 = path.getOrDefault("cacheId")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "cacheId", valid_593959
  var valid_593960 = path.getOrDefault("serviceName")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "serviceName", valid_593960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593962: Call_CacheGet_593954; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the Cache specified by its identifier.
  ## 
  let valid = call_593962.validator(path, query, header, formData, body)
  let scheme = call_593962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593962.url(scheme.get, call_593962.host, call_593962.base,
                         call_593962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593962, url, valid)

proc call*(call_593963: Call_CacheGet_593954; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; cacheId: string;
          serviceName: string): Recallable =
  ## cacheGet
  ## Gets the details of the Cache specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheId: string (required)
  ##          : Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_593964 = newJObject()
  var query_593965 = newJObject()
  add(path_593964, "resourceGroupName", newJString(resourceGroupName))
  add(query_593965, "api-version", newJString(apiVersion))
  add(path_593964, "subscriptionId", newJString(subscriptionId))
  add(path_593964, "cacheId", newJString(cacheId))
  add(path_593964, "serviceName", newJString(serviceName))
  result = call_593963.call(path_593964, query_593965, nil, nil, nil)

var cacheGet* = Call_CacheGet_593954(name: "cacheGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/caches/{cacheId}",
                                  validator: validate_CacheGet_593955, base: "",
                                  url: url_CacheGet_593956,
                                  schemes: {Scheme.Https})
type
  Call_CacheUpdate_594033 = ref object of OpenApiRestCall_593424
proc url_CacheUpdate_594035(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "cacheId" in path, "`cacheId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/caches/"),
               (kind: VariableSegment, value: "cacheId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CacheUpdate_594034(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of the cache specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheId: JString (required)
  ##          : Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594036 = path.getOrDefault("resourceGroupName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "resourceGroupName", valid_594036
  var valid_594037 = path.getOrDefault("subscriptionId")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "subscriptionId", valid_594037
  var valid_594038 = path.getOrDefault("cacheId")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "cacheId", valid_594038
  var valid_594039 = path.getOrDefault("serviceName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "serviceName", valid_594039
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594040 = query.getOrDefault("api-version")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "api-version", valid_594040
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594041 = header.getOrDefault("If-Match")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "If-Match", valid_594041
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594043: Call_CacheUpdate_594033; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the cache specified by its identifier.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_CacheUpdate_594033; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; cacheId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## cacheUpdate
  ## Updates the details of the cache specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheId: string (required)
  ##          : Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594045 = newJObject()
  var query_594046 = newJObject()
  var body_594047 = newJObject()
  add(path_594045, "resourceGroupName", newJString(resourceGroupName))
  add(query_594046, "api-version", newJString(apiVersion))
  add(path_594045, "subscriptionId", newJString(subscriptionId))
  add(path_594045, "cacheId", newJString(cacheId))
  if parameters != nil:
    body_594047 = parameters
  add(path_594045, "serviceName", newJString(serviceName))
  result = call_594044.call(path_594045, query_594046, nil, nil, body_594047)

var cacheUpdate* = Call_CacheUpdate_594033(name: "cacheUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/caches/{cacheId}",
                                        validator: validate_CacheUpdate_594034,
                                        base: "", url: url_CacheUpdate_594035,
                                        schemes: {Scheme.Https})
type
  Call_CacheDelete_594008 = ref object of OpenApiRestCall_593424
proc url_CacheDelete_594010(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "cacheId" in path, "`cacheId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/caches/"),
               (kind: VariableSegment, value: "cacheId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CacheDelete_594009(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specific Cache.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheId: JString (required)
  ##          : Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594011 = path.getOrDefault("resourceGroupName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "resourceGroupName", valid_594011
  var valid_594012 = path.getOrDefault("subscriptionId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "subscriptionId", valid_594012
  var valid_594013 = path.getOrDefault("cacheId")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "cacheId", valid_594013
  var valid_594014 = path.getOrDefault("serviceName")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "serviceName", valid_594014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594015 = query.getOrDefault("api-version")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "api-version", valid_594015
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594016 = header.getOrDefault("If-Match")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "If-Match", valid_594016
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_CacheDelete_594008; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific Cache.
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_CacheDelete_594008; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; cacheId: string;
          serviceName: string): Recallable =
  ## cacheDelete
  ## Deletes specific Cache.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheId: string (required)
  ##          : Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  add(path_594019, "resourceGroupName", newJString(resourceGroupName))
  add(query_594020, "api-version", newJString(apiVersion))
  add(path_594019, "subscriptionId", newJString(subscriptionId))
  add(path_594019, "cacheId", newJString(cacheId))
  add(path_594019, "serviceName", newJString(serviceName))
  result = call_594018.call(path_594019, query_594020, nil, nil, nil)

var cacheDelete* = Call_CacheDelete_594008(name: "cacheDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/caches/{cacheId}",
                                        validator: validate_CacheDelete_594009,
                                        base: "", url: url_CacheDelete_594010,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
