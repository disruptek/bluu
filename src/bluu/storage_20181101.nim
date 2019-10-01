
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: StorageManagementClient
## version: 2018-11-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure Storage Management API.
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

  OpenApiRestCall_567667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567667): Option[Scheme] {.used.} =
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
  macServiceName = "storage"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567889 = ref object of OpenApiRestCall_567667
proc url_OperationsList_567891(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567890(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Storage Rest API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568037 = query.getOrDefault("api-version")
  valid_568037 = validateParameter(valid_568037, JString, required = true,
                                 default = nil)
  if valid_568037 != nil:
    section.add "api-version", valid_568037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_OperationsList_567889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Storage Rest API operations.
  ## 
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_OperationsList_567889; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Storage Rest API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  result = call_568135.call(nil, query_568136, nil, nil, nil)

var operationsList* = Call_OperationsList_567889(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Storage/operations",
    validator: validate_OperationsList_567890, base: "", url: url_OperationsList_567891,
    schemes: {Scheme.Https})
type
  Call_StorageAccountsCheckNameAvailability_568176 = ref object of OpenApiRestCall_567667
proc url_StorageAccountsCheckNameAvailability_568178(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsCheckNameAvailability_568177(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that the storage account name is valid and is not already in use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568219 = path.getOrDefault("subscriptionId")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "subscriptionId", valid_568219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568220 = query.getOrDefault("api-version")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "api-version", valid_568220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   accountName: JObject (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_StorageAccountsCheckNameAvailability_568176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks that the storage account name is valid and is not already in use.
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_StorageAccountsCheckNameAvailability_568176;
          apiVersion: string; accountName: JsonNode; subscriptionId: string): Recallable =
  ## storageAccountsCheckNameAvailability
  ## Checks that the storage account name is valid and is not already in use.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   accountName: JObject (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  var body_568226 = newJObject()
  add(query_568225, "api-version", newJString(apiVersion))
  if accountName != nil:
    body_568226 = accountName
  add(path_568224, "subscriptionId", newJString(subscriptionId))
  result = call_568223.call(path_568224, query_568225, nil, nil, body_568226)

var storageAccountsCheckNameAvailability* = Call_StorageAccountsCheckNameAvailability_568176(
    name: "storageAccountsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage/checkNameAvailability",
    validator: validate_StorageAccountsCheckNameAvailability_568177, base: "",
    url: url_StorageAccountsCheckNameAvailability_568178, schemes: {Scheme.Https})
type
  Call_UsagesListByLocation_568227 = ref object of OpenApiRestCall_567667
proc url_UsagesListByLocation_568229(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsagesListByLocation_568228(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current usage count and the limit for the resources of the location under the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   location: JString (required)
  ##           : The location of the Azure Storage resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568230 = path.getOrDefault("subscriptionId")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "subscriptionId", valid_568230
  var valid_568231 = path.getOrDefault("location")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "location", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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

proc call*(call_568233: Call_UsagesListByLocation_568227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current usage count and the limit for the resources of the location under the subscription.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_UsagesListByLocation_568227; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usagesListByLocation
  ## Gets the current usage count and the limit for the resources of the location under the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   location: string (required)
  ##           : The location of the Azure Storage resource.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  add(path_568235, "location", newJString(location))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var usagesListByLocation* = Call_UsagesListByLocation_568227(
    name: "usagesListByLocation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage/locations/{location}/usages",
    validator: validate_UsagesListByLocation_568228, base: "",
    url: url_UsagesListByLocation_568229, schemes: {Scheme.Https})
type
  Call_SkusList_568237 = ref object of OpenApiRestCall_567667
proc url_SkusList_568239(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SkusList_568238(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the available SKUs supported by Microsoft.Storage for given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568240 = path.getOrDefault("subscriptionId")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "subscriptionId", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "api-version", valid_568241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568242: Call_SkusList_568237; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available SKUs supported by Microsoft.Storage for given subscription.
  ## 
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_SkusList_568237; apiVersion: string;
          subscriptionId: string): Recallable =
  ## skusList
  ## Lists the available SKUs supported by Microsoft.Storage for given subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  add(query_568245, "api-version", newJString(apiVersion))
  add(path_568244, "subscriptionId", newJString(subscriptionId))
  result = call_568243.call(path_568244, query_568245, nil, nil, nil)

var skusList* = Call_SkusList_568237(name: "skusList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage/skus",
                                  validator: validate_SkusList_568238, base: "",
                                  url: url_SkusList_568239,
                                  schemes: {Scheme.Https})
type
  Call_StorageAccountsList_568246 = ref object of OpenApiRestCall_567667
proc url_StorageAccountsList_568248(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsList_568247(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568249 = path.getOrDefault("subscriptionId")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "subscriptionId", valid_568249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568250 = query.getOrDefault("api-version")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "api-version", valid_568250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568251: Call_StorageAccountsList_568246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
  ## 
  let valid = call_568251.validator(path, query, header, formData, body)
  let scheme = call_568251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568251.url(scheme.get, call_568251.host, call_568251.base,
                         call_568251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568251, url, valid)

proc call*(call_568252: Call_StorageAccountsList_568246; apiVersion: string;
          subscriptionId: string): Recallable =
  ## storageAccountsList
  ## Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568253 = newJObject()
  var query_568254 = newJObject()
  add(query_568254, "api-version", newJString(apiVersion))
  add(path_568253, "subscriptionId", newJString(subscriptionId))
  result = call_568252.call(path_568253, query_568254, nil, nil, nil)

var storageAccountsList* = Call_StorageAccountsList_568246(
    name: "storageAccountsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage/storageAccounts",
    validator: validate_StorageAccountsList_568247, base: "",
    url: url_StorageAccountsList_568248, schemes: {Scheme.Https})
type
  Call_StorageAccountsListByResourceGroup_568255 = ref object of OpenApiRestCall_567667
proc url_StorageAccountsListByResourceGroup_568257(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsListByResourceGroup_568256(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568258 = path.getOrDefault("resourceGroupName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "resourceGroupName", valid_568258
  var valid_568259 = path.getOrDefault("subscriptionId")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "subscriptionId", valid_568259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568260 = query.getOrDefault("api-version")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "api-version", valid_568260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568261: Call_StorageAccountsListByResourceGroup_568255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
  ## 
  let valid = call_568261.validator(path, query, header, formData, body)
  let scheme = call_568261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568261.url(scheme.get, call_568261.host, call_568261.base,
                         call_568261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568261, url, valid)

proc call*(call_568262: Call_StorageAccountsListByResourceGroup_568255;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## storageAccountsListByResourceGroup
  ## Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568263 = newJObject()
  var query_568264 = newJObject()
  add(path_568263, "resourceGroupName", newJString(resourceGroupName))
  add(query_568264, "api-version", newJString(apiVersion))
  add(path_568263, "subscriptionId", newJString(subscriptionId))
  result = call_568262.call(path_568263, query_568264, nil, nil, nil)

var storageAccountsListByResourceGroup* = Call_StorageAccountsListByResourceGroup_568255(
    name: "storageAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts",
    validator: validate_StorageAccountsListByResourceGroup_568256, base: "",
    url: url_StorageAccountsListByResourceGroup_568257, schemes: {Scheme.Https})
type
  Call_StorageAccountsCreate_568291 = ref object of OpenApiRestCall_567667
proc url_StorageAccountsCreate_568293(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsCreate_568292(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronously creates a new storage account with the specified parameters. If an account is already created and a subsequent create request is issued with different properties, the account properties will be updated. If an account is already created and a subsequent create or update request is issued with the exact same set of properties, the request will succeed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568294 = path.getOrDefault("resourceGroupName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "resourceGroupName", valid_568294
  var valid_568295 = path.getOrDefault("subscriptionId")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "subscriptionId", valid_568295
  var valid_568296 = path.getOrDefault("accountName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "accountName", valid_568296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568297 = query.getOrDefault("api-version")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "api-version", valid_568297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568299: Call_StorageAccountsCreate_568291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously creates a new storage account with the specified parameters. If an account is already created and a subsequent create request is issued with different properties, the account properties will be updated. If an account is already created and a subsequent create or update request is issued with the exact same set of properties, the request will succeed.
  ## 
  let valid = call_568299.validator(path, query, header, formData, body)
  let scheme = call_568299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568299.url(scheme.get, call_568299.host, call_568299.base,
                         call_568299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568299, url, valid)

proc call*(call_568300: Call_StorageAccountsCreate_568291;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## storageAccountsCreate
  ## Asynchronously creates a new storage account with the specified parameters. If an account is already created and a subsequent create request is issued with different properties, the account properties will be updated. If an account is already created and a subsequent create or update request is issued with the exact same set of properties, the request will succeed.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created account.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568301 = newJObject()
  var query_568302 = newJObject()
  var body_568303 = newJObject()
  add(path_568301, "resourceGroupName", newJString(resourceGroupName))
  add(query_568302, "api-version", newJString(apiVersion))
  add(path_568301, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568303 = parameters
  add(path_568301, "accountName", newJString(accountName))
  result = call_568300.call(path_568301, query_568302, nil, nil, body_568303)

var storageAccountsCreate* = Call_StorageAccountsCreate_568291(
    name: "storageAccountsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}",
    validator: validate_StorageAccountsCreate_568292, base: "",
    url: url_StorageAccountsCreate_568293, schemes: {Scheme.Https})
type
  Call_StorageAccountsGetProperties_568265 = ref object of OpenApiRestCall_567667
proc url_StorageAccountsGetProperties_568267(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsGetProperties_568266(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties for the specified storage account including but not limited to name, SKU name, location, and account status. The ListKeys operation should be used to retrieve storage keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568269 = path.getOrDefault("resourceGroupName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "resourceGroupName", valid_568269
  var valid_568270 = path.getOrDefault("subscriptionId")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "subscriptionId", valid_568270
  var valid_568271 = path.getOrDefault("accountName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "accountName", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : May be used to expand the properties within account's properties. By default, data is not included when fetching properties. Currently we only support geoReplicationStats.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  var valid_568286 = query.getOrDefault("$expand")
  valid_568286 = validateParameter(valid_568286, JString, required = false,
                                 default = newJString("geoReplicationStats"))
  if valid_568286 != nil:
    section.add "$expand", valid_568286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568287: Call_StorageAccountsGetProperties_568265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties for the specified storage account including but not limited to name, SKU name, location, and account status. The ListKeys operation should be used to retrieve storage keys.
  ## 
  let valid = call_568287.validator(path, query, header, formData, body)
  let scheme = call_568287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568287.url(scheme.get, call_568287.host, call_568287.base,
                         call_568287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568287, url, valid)

proc call*(call_568288: Call_StorageAccountsGetProperties_568265;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; Expand: string = "geoReplicationStats"): Recallable =
  ## storageAccountsGetProperties
  ## Returns the properties for the specified storage account including but not limited to name, SKU name, location, and account status. The ListKeys operation should be used to retrieve storage keys.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : May be used to expand the properties within account's properties. By default, data is not included when fetching properties. Currently we only support geoReplicationStats.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568289 = newJObject()
  var query_568290 = newJObject()
  add(path_568289, "resourceGroupName", newJString(resourceGroupName))
  add(query_568290, "api-version", newJString(apiVersion))
  add(query_568290, "$expand", newJString(Expand))
  add(path_568289, "subscriptionId", newJString(subscriptionId))
  add(path_568289, "accountName", newJString(accountName))
  result = call_568288.call(path_568289, query_568290, nil, nil, nil)

var storageAccountsGetProperties* = Call_StorageAccountsGetProperties_568265(
    name: "storageAccountsGetProperties", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}",
    validator: validate_StorageAccountsGetProperties_568266, base: "",
    url: url_StorageAccountsGetProperties_568267, schemes: {Scheme.Https})
type
  Call_StorageAccountsUpdate_568315 = ref object of OpenApiRestCall_567667
proc url_StorageAccountsUpdate_568317(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsUpdate_568316(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The update operation can be used to update the SKU, encryption, access tier, or tags for a storage account. It can also be used to map the account to a custom domain. Only one custom domain is supported per storage account; the replacement/change of custom domain is not supported. In order to replace an old custom domain, the old value must be cleared/unregistered before a new value can be set. The update of multiple properties is supported. This call does not change the storage keys for the account. If you want to change the storage account keys, use the regenerate keys operation. The location and name of the storage account cannot be changed after creation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568318 = path.getOrDefault("resourceGroupName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "resourceGroupName", valid_568318
  var valid_568319 = path.getOrDefault("subscriptionId")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "subscriptionId", valid_568319
  var valid_568320 = path.getOrDefault("accountName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "accountName", valid_568320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568321 = query.getOrDefault("api-version")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "api-version", valid_568321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the updated account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568323: Call_StorageAccountsUpdate_568315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The update operation can be used to update the SKU, encryption, access tier, or tags for a storage account. It can also be used to map the account to a custom domain. Only one custom domain is supported per storage account; the replacement/change of custom domain is not supported. In order to replace an old custom domain, the old value must be cleared/unregistered before a new value can be set. The update of multiple properties is supported. This call does not change the storage keys for the account. If you want to change the storage account keys, use the regenerate keys operation. The location and name of the storage account cannot be changed after creation.
  ## 
  let valid = call_568323.validator(path, query, header, formData, body)
  let scheme = call_568323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568323.url(scheme.get, call_568323.host, call_568323.base,
                         call_568323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568323, url, valid)

proc call*(call_568324: Call_StorageAccountsUpdate_568315;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## storageAccountsUpdate
  ## The update operation can be used to update the SKU, encryption, access tier, or tags for a storage account. It can also be used to map the account to a custom domain. Only one custom domain is supported per storage account; the replacement/change of custom domain is not supported. In order to replace an old custom domain, the old value must be cleared/unregistered before a new value can be set. The update of multiple properties is supported. This call does not change the storage keys for the account. If you want to change the storage account keys, use the regenerate keys operation. The location and name of the storage account cannot be changed after creation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the updated account.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568325 = newJObject()
  var query_568326 = newJObject()
  var body_568327 = newJObject()
  add(path_568325, "resourceGroupName", newJString(resourceGroupName))
  add(query_568326, "api-version", newJString(apiVersion))
  add(path_568325, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568327 = parameters
  add(path_568325, "accountName", newJString(accountName))
  result = call_568324.call(path_568325, query_568326, nil, nil, body_568327)

var storageAccountsUpdate* = Call_StorageAccountsUpdate_568315(
    name: "storageAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}",
    validator: validate_StorageAccountsUpdate_568316, base: "",
    url: url_StorageAccountsUpdate_568317, schemes: {Scheme.Https})
type
  Call_StorageAccountsDelete_568304 = ref object of OpenApiRestCall_567667
proc url_StorageAccountsDelete_568306(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsDelete_568305(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a storage account in Microsoft Azure.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568307 = path.getOrDefault("resourceGroupName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "resourceGroupName", valid_568307
  var valid_568308 = path.getOrDefault("subscriptionId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "subscriptionId", valid_568308
  var valid_568309 = path.getOrDefault("accountName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "accountName", valid_568309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568310 = query.getOrDefault("api-version")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "api-version", valid_568310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568311: Call_StorageAccountsDelete_568304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a storage account in Microsoft Azure.
  ## 
  let valid = call_568311.validator(path, query, header, formData, body)
  let scheme = call_568311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568311.url(scheme.get, call_568311.host, call_568311.base,
                         call_568311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568311, url, valid)

proc call*(call_568312: Call_StorageAccountsDelete_568304;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## storageAccountsDelete
  ## Deletes a storage account in Microsoft Azure.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568313 = newJObject()
  var query_568314 = newJObject()
  add(path_568313, "resourceGroupName", newJString(resourceGroupName))
  add(query_568314, "api-version", newJString(apiVersion))
  add(path_568313, "subscriptionId", newJString(subscriptionId))
  add(path_568313, "accountName", newJString(accountName))
  result = call_568312.call(path_568313, query_568314, nil, nil, nil)

var storageAccountsDelete* = Call_StorageAccountsDelete_568304(
    name: "storageAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}",
    validator: validate_StorageAccountsDelete_568305, base: "",
    url: url_StorageAccountsDelete_568306, schemes: {Scheme.Https})
type
  Call_StorageAccountsListAccountSAS_568328 = ref object of OpenApiRestCall_567667
proc url_StorageAccountsListAccountSAS_568330(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/ListAccountSas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsListAccountSAS_568329(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List SAS credentials of a storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568331 = path.getOrDefault("resourceGroupName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "resourceGroupName", valid_568331
  var valid_568332 = path.getOrDefault("subscriptionId")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "subscriptionId", valid_568332
  var valid_568333 = path.getOrDefault("accountName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "accountName", valid_568333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568334 = query.getOrDefault("api-version")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "api-version", valid_568334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide to list SAS credentials for the storage account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568336: Call_StorageAccountsListAccountSAS_568328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List SAS credentials of a storage account.
  ## 
  let valid = call_568336.validator(path, query, header, formData, body)
  let scheme = call_568336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568336.url(scheme.get, call_568336.host, call_568336.base,
                         call_568336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568336, url, valid)

proc call*(call_568337: Call_StorageAccountsListAccountSAS_568328;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## storageAccountsListAccountSAS
  ## List SAS credentials of a storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : The parameters to provide to list SAS credentials for the storage account.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568338 = newJObject()
  var query_568339 = newJObject()
  var body_568340 = newJObject()
  add(path_568338, "resourceGroupName", newJString(resourceGroupName))
  add(query_568339, "api-version", newJString(apiVersion))
  add(path_568338, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568340 = parameters
  add(path_568338, "accountName", newJString(accountName))
  result = call_568337.call(path_568338, query_568339, nil, nil, body_568340)

var storageAccountsListAccountSAS* = Call_StorageAccountsListAccountSAS_568328(
    name: "storageAccountsListAccountSAS", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/ListAccountSas",
    validator: validate_StorageAccountsListAccountSAS_568329, base: "",
    url: url_StorageAccountsListAccountSAS_568330, schemes: {Scheme.Https})
type
  Call_StorageAccountsListServiceSAS_568341 = ref object of OpenApiRestCall_567667
proc url_StorageAccountsListServiceSAS_568343(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/ListServiceSas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsListServiceSAS_568342(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List service SAS credentials of a specific resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568354 = path.getOrDefault("resourceGroupName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "resourceGroupName", valid_568354
  var valid_568355 = path.getOrDefault("subscriptionId")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "subscriptionId", valid_568355
  var valid_568356 = path.getOrDefault("accountName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "accountName", valid_568356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568357 = query.getOrDefault("api-version")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "api-version", valid_568357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide to list service SAS credentials.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568359: Call_StorageAccountsListServiceSAS_568341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List service SAS credentials of a specific resource.
  ## 
  let valid = call_568359.validator(path, query, header, formData, body)
  let scheme = call_568359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568359.url(scheme.get, call_568359.host, call_568359.base,
                         call_568359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568359, url, valid)

proc call*(call_568360: Call_StorageAccountsListServiceSAS_568341;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## storageAccountsListServiceSAS
  ## List service SAS credentials of a specific resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : The parameters to provide to list service SAS credentials.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568361 = newJObject()
  var query_568362 = newJObject()
  var body_568363 = newJObject()
  add(path_568361, "resourceGroupName", newJString(resourceGroupName))
  add(query_568362, "api-version", newJString(apiVersion))
  add(path_568361, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568363 = parameters
  add(path_568361, "accountName", newJString(accountName))
  result = call_568360.call(path_568361, query_568362, nil, nil, body_568363)

var storageAccountsListServiceSAS* = Call_StorageAccountsListServiceSAS_568341(
    name: "storageAccountsListServiceSAS", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/ListServiceSas",
    validator: validate_StorageAccountsListServiceSAS_568342, base: "",
    url: url_StorageAccountsListServiceSAS_568343, schemes: {Scheme.Https})
type
  Call_StorageAccountsFailover_568364 = ref object of OpenApiRestCall_567667
proc url_StorageAccountsFailover_568366(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsFailover_568365(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Failover request can be triggered for a storage account in case of availability issues. The failover occurs from the storage account's primary cluster to secondary cluster for RA-GRS accounts. The secondary cluster will become primary after failover.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568367 = path.getOrDefault("resourceGroupName")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "resourceGroupName", valid_568367
  var valid_568368 = path.getOrDefault("subscriptionId")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "subscriptionId", valid_568368
  var valid_568369 = path.getOrDefault("accountName")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "accountName", valid_568369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568370 = query.getOrDefault("api-version")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "api-version", valid_568370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568371: Call_StorageAccountsFailover_568364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Failover request can be triggered for a storage account in case of availability issues. The failover occurs from the storage account's primary cluster to secondary cluster for RA-GRS accounts. The secondary cluster will become primary after failover.
  ## 
  let valid = call_568371.validator(path, query, header, formData, body)
  let scheme = call_568371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568371.url(scheme.get, call_568371.host, call_568371.base,
                         call_568371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568371, url, valid)

proc call*(call_568372: Call_StorageAccountsFailover_568364;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## storageAccountsFailover
  ## Failover request can be triggered for a storage account in case of availability issues. The failover occurs from the storage account's primary cluster to secondary cluster for RA-GRS accounts. The secondary cluster will become primary after failover.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568373 = newJObject()
  var query_568374 = newJObject()
  add(path_568373, "resourceGroupName", newJString(resourceGroupName))
  add(query_568374, "api-version", newJString(apiVersion))
  add(path_568373, "subscriptionId", newJString(subscriptionId))
  add(path_568373, "accountName", newJString(accountName))
  result = call_568372.call(path_568373, query_568374, nil, nil, nil)

var storageAccountsFailover* = Call_StorageAccountsFailover_568364(
    name: "storageAccountsFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/failover",
    validator: validate_StorageAccountsFailover_568365, base: "",
    url: url_StorageAccountsFailover_568366, schemes: {Scheme.Https})
type
  Call_StorageAccountsListKeys_568375 = ref object of OpenApiRestCall_567667
proc url_StorageAccountsListKeys_568377(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsListKeys_568376(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the access keys for the specified storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568378 = path.getOrDefault("resourceGroupName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "resourceGroupName", valid_568378
  var valid_568379 = path.getOrDefault("subscriptionId")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "subscriptionId", valid_568379
  var valid_568380 = path.getOrDefault("accountName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "accountName", valid_568380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568381 = query.getOrDefault("api-version")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "api-version", valid_568381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568382: Call_StorageAccountsListKeys_568375; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the access keys for the specified storage account.
  ## 
  let valid = call_568382.validator(path, query, header, formData, body)
  let scheme = call_568382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568382.url(scheme.get, call_568382.host, call_568382.base,
                         call_568382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568382, url, valid)

proc call*(call_568383: Call_StorageAccountsListKeys_568375;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## storageAccountsListKeys
  ## Lists the access keys for the specified storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568384 = newJObject()
  var query_568385 = newJObject()
  add(path_568384, "resourceGroupName", newJString(resourceGroupName))
  add(query_568385, "api-version", newJString(apiVersion))
  add(path_568384, "subscriptionId", newJString(subscriptionId))
  add(path_568384, "accountName", newJString(accountName))
  result = call_568383.call(path_568384, query_568385, nil, nil, nil)

var storageAccountsListKeys* = Call_StorageAccountsListKeys_568375(
    name: "storageAccountsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/listKeys",
    validator: validate_StorageAccountsListKeys_568376, base: "",
    url: url_StorageAccountsListKeys_568377, schemes: {Scheme.Https})
type
  Call_ManagementPoliciesCreateOrUpdate_568398 = ref object of OpenApiRestCall_567667
proc url_ManagementPoliciesCreateOrUpdate_568400(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "managementPolicyName" in path,
        "`managementPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/managementPolicies/"),
               (kind: VariableSegment, value: "managementPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementPoliciesCreateOrUpdate_568399(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the managementpolicy to the specified storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   managementPolicyName: JString (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568401 = path.getOrDefault("resourceGroupName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "resourceGroupName", valid_568401
  var valid_568402 = path.getOrDefault("subscriptionId")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "subscriptionId", valid_568402
  var valid_568403 = path.getOrDefault("managementPolicyName")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = newJString("default"))
  if valid_568403 != nil:
    section.add "managementPolicyName", valid_568403
  var valid_568404 = path.getOrDefault("accountName")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "accountName", valid_568404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568405 = query.getOrDefault("api-version")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "api-version", valid_568405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   properties: JObject (required)
  ##             : The ManagementPolicy set to a storage account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568407: Call_ManagementPoliciesCreateOrUpdate_568398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the managementpolicy to the specified storage account.
  ## 
  let valid = call_568407.validator(path, query, header, formData, body)
  let scheme = call_568407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568407.url(scheme.get, call_568407.host, call_568407.base,
                         call_568407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568407, url, valid)

proc call*(call_568408: Call_ManagementPoliciesCreateOrUpdate_568398;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          properties: JsonNode; accountName: string;
          managementPolicyName: string = "default"): Recallable =
  ## managementPoliciesCreateOrUpdate
  ## Sets the managementpolicy to the specified storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   managementPolicyName: string (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   properties: JObject (required)
  ##             : The ManagementPolicy set to a storage account.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568409 = newJObject()
  var query_568410 = newJObject()
  var body_568411 = newJObject()
  add(path_568409, "resourceGroupName", newJString(resourceGroupName))
  add(query_568410, "api-version", newJString(apiVersion))
  add(path_568409, "subscriptionId", newJString(subscriptionId))
  add(path_568409, "managementPolicyName", newJString(managementPolicyName))
  if properties != nil:
    body_568411 = properties
  add(path_568409, "accountName", newJString(accountName))
  result = call_568408.call(path_568409, query_568410, nil, nil, body_568411)

var managementPoliciesCreateOrUpdate* = Call_ManagementPoliciesCreateOrUpdate_568398(
    name: "managementPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/managementPolicies/{managementPolicyName}",
    validator: validate_ManagementPoliciesCreateOrUpdate_568399, base: "",
    url: url_ManagementPoliciesCreateOrUpdate_568400, schemes: {Scheme.Https})
type
  Call_ManagementPoliciesGet_568386 = ref object of OpenApiRestCall_567667
proc url_ManagementPoliciesGet_568388(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "managementPolicyName" in path,
        "`managementPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/managementPolicies/"),
               (kind: VariableSegment, value: "managementPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementPoliciesGet_568387(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the managementpolicy associated with the specified storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   managementPolicyName: JString (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568389 = path.getOrDefault("resourceGroupName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "resourceGroupName", valid_568389
  var valid_568390 = path.getOrDefault("subscriptionId")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "subscriptionId", valid_568390
  var valid_568391 = path.getOrDefault("managementPolicyName")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = newJString("default"))
  if valid_568391 != nil:
    section.add "managementPolicyName", valid_568391
  var valid_568392 = path.getOrDefault("accountName")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "accountName", valid_568392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568393 = query.getOrDefault("api-version")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "api-version", valid_568393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568394: Call_ManagementPoliciesGet_568386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the managementpolicy associated with the specified storage account.
  ## 
  let valid = call_568394.validator(path, query, header, formData, body)
  let scheme = call_568394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568394.url(scheme.get, call_568394.host, call_568394.base,
                         call_568394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568394, url, valid)

proc call*(call_568395: Call_ManagementPoliciesGet_568386;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; managementPolicyName: string = "default"): Recallable =
  ## managementPoliciesGet
  ## Gets the managementpolicy associated with the specified storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   managementPolicyName: string (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568396 = newJObject()
  var query_568397 = newJObject()
  add(path_568396, "resourceGroupName", newJString(resourceGroupName))
  add(query_568397, "api-version", newJString(apiVersion))
  add(path_568396, "subscriptionId", newJString(subscriptionId))
  add(path_568396, "managementPolicyName", newJString(managementPolicyName))
  add(path_568396, "accountName", newJString(accountName))
  result = call_568395.call(path_568396, query_568397, nil, nil, nil)

var managementPoliciesGet* = Call_ManagementPoliciesGet_568386(
    name: "managementPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/managementPolicies/{managementPolicyName}",
    validator: validate_ManagementPoliciesGet_568387, base: "",
    url: url_ManagementPoliciesGet_568388, schemes: {Scheme.Https})
type
  Call_ManagementPoliciesDelete_568412 = ref object of OpenApiRestCall_567667
proc url_ManagementPoliciesDelete_568414(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "managementPolicyName" in path,
        "`managementPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/managementPolicies/"),
               (kind: VariableSegment, value: "managementPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementPoliciesDelete_568413(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the managementpolicy associated with the specified storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   managementPolicyName: JString (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568415 = path.getOrDefault("resourceGroupName")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "resourceGroupName", valid_568415
  var valid_568416 = path.getOrDefault("subscriptionId")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "subscriptionId", valid_568416
  var valid_568417 = path.getOrDefault("managementPolicyName")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = newJString("default"))
  if valid_568417 != nil:
    section.add "managementPolicyName", valid_568417
  var valid_568418 = path.getOrDefault("accountName")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "accountName", valid_568418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568419 = query.getOrDefault("api-version")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "api-version", valid_568419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568420: Call_ManagementPoliciesDelete_568412; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the managementpolicy associated with the specified storage account.
  ## 
  let valid = call_568420.validator(path, query, header, formData, body)
  let scheme = call_568420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568420.url(scheme.get, call_568420.host, call_568420.base,
                         call_568420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568420, url, valid)

proc call*(call_568421: Call_ManagementPoliciesDelete_568412;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; managementPolicyName: string = "default"): Recallable =
  ## managementPoliciesDelete
  ## Deletes the managementpolicy associated with the specified storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   managementPolicyName: string (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568422 = newJObject()
  var query_568423 = newJObject()
  add(path_568422, "resourceGroupName", newJString(resourceGroupName))
  add(query_568423, "api-version", newJString(apiVersion))
  add(path_568422, "subscriptionId", newJString(subscriptionId))
  add(path_568422, "managementPolicyName", newJString(managementPolicyName))
  add(path_568422, "accountName", newJString(accountName))
  result = call_568421.call(path_568422, query_568423, nil, nil, nil)

var managementPoliciesDelete* = Call_ManagementPoliciesDelete_568412(
    name: "managementPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/managementPolicies/{managementPolicyName}",
    validator: validate_ManagementPoliciesDelete_568413, base: "",
    url: url_ManagementPoliciesDelete_568414, schemes: {Scheme.Https})
type
  Call_StorageAccountsRegenerateKey_568424 = ref object of OpenApiRestCall_567667
proc url_StorageAccountsRegenerateKey_568426(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/regenerateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsRegenerateKey_568425(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates one of the access keys for the specified storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568427 = path.getOrDefault("resourceGroupName")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "resourceGroupName", valid_568427
  var valid_568428 = path.getOrDefault("subscriptionId")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "subscriptionId", valid_568428
  var valid_568429 = path.getOrDefault("accountName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "accountName", valid_568429
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568430 = query.getOrDefault("api-version")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "api-version", valid_568430
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regenerateKey: JObject (required)
  ##                : Specifies name of the key which should be regenerated -- key1 or key2.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568432: Call_StorageAccountsRegenerateKey_568424; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates one of the access keys for the specified storage account.
  ## 
  let valid = call_568432.validator(path, query, header, formData, body)
  let scheme = call_568432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568432.url(scheme.get, call_568432.host, call_568432.base,
                         call_568432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568432, url, valid)

proc call*(call_568433: Call_StorageAccountsRegenerateKey_568424;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          regenerateKey: JsonNode; accountName: string): Recallable =
  ## storageAccountsRegenerateKey
  ## Regenerates one of the access keys for the specified storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   regenerateKey: JObject (required)
  ##                : Specifies name of the key which should be regenerated -- key1 or key2.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568434 = newJObject()
  var query_568435 = newJObject()
  var body_568436 = newJObject()
  add(path_568434, "resourceGroupName", newJString(resourceGroupName))
  add(query_568435, "api-version", newJString(apiVersion))
  add(path_568434, "subscriptionId", newJString(subscriptionId))
  if regenerateKey != nil:
    body_568436 = regenerateKey
  add(path_568434, "accountName", newJString(accountName))
  result = call_568433.call(path_568434, query_568435, nil, nil, body_568436)

var storageAccountsRegenerateKey* = Call_StorageAccountsRegenerateKey_568424(
    name: "storageAccountsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/regenerateKey",
    validator: validate_StorageAccountsRegenerateKey_568425, base: "",
    url: url_StorageAccountsRegenerateKey_568426, schemes: {Scheme.Https})
type
  Call_StorageAccountsRevokeUserDelegationKeys_568437 = ref object of OpenApiRestCall_567667
proc url_StorageAccountsRevokeUserDelegationKeys_568439(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/revokeUserDelegationKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsRevokeUserDelegationKeys_568438(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revoke user delegation keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568440 = path.getOrDefault("resourceGroupName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "resourceGroupName", valid_568440
  var valid_568441 = path.getOrDefault("subscriptionId")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "subscriptionId", valid_568441
  var valid_568442 = path.getOrDefault("accountName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "accountName", valid_568442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568443 = query.getOrDefault("api-version")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "api-version", valid_568443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568444: Call_StorageAccountsRevokeUserDelegationKeys_568437;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revoke user delegation keys.
  ## 
  let valid = call_568444.validator(path, query, header, formData, body)
  let scheme = call_568444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568444.url(scheme.get, call_568444.host, call_568444.base,
                         call_568444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568444, url, valid)

proc call*(call_568445: Call_StorageAccountsRevokeUserDelegationKeys_568437;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## storageAccountsRevokeUserDelegationKeys
  ## Revoke user delegation keys.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568446 = newJObject()
  var query_568447 = newJObject()
  add(path_568446, "resourceGroupName", newJString(resourceGroupName))
  add(query_568447, "api-version", newJString(apiVersion))
  add(path_568446, "subscriptionId", newJString(subscriptionId))
  add(path_568446, "accountName", newJString(accountName))
  result = call_568445.call(path_568446, query_568447, nil, nil, nil)

var storageAccountsRevokeUserDelegationKeys* = Call_StorageAccountsRevokeUserDelegationKeys_568437(
    name: "storageAccountsRevokeUserDelegationKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/revokeUserDelegationKeys",
    validator: validate_StorageAccountsRevokeUserDelegationKeys_568438, base: "",
    url: url_StorageAccountsRevokeUserDelegationKeys_568439,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
