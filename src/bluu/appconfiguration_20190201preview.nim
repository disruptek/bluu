
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AppConfigurationManagementClient
## version: 2019-02-01-preview
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "appconfiguration"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567880 = ref object of OpenApiRestCall_567658
proc url_OperationsList_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567881(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists the operations available from this provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  ##   $skipToken: JString
  ##             : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568042 = query.getOrDefault("api-version")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "api-version", valid_568042
  var valid_568043 = query.getOrDefault("$skipToken")
  valid_568043 = validateParameter(valid_568043, JString, required = false,
                                 default = nil)
  if valid_568043 != nil:
    section.add "$skipToken", valid_568043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568066: Call_OperationsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the operations available from this provider.
  ## 
  let valid = call_568066.validator(path, query, header, formData, body)
  let scheme = call_568066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568066.url(scheme.get, call_568066.host, call_568066.base,
                         call_568066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568066, url, valid)

proc call*(call_568137: Call_OperationsList_567880; apiVersion: string;
          SkipToken: string = ""): Recallable =
  ## operationsList
  ## Lists the operations available from this provider.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   SkipToken: string
  ##            : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  var query_568138 = newJObject()
  add(query_568138, "api-version", newJString(apiVersion))
  add(query_568138, "$skipToken", newJString(SkipToken))
  result = call_568137.call(nil, query_568138, nil, nil, nil)

var operationsList* = Call_OperationsList_567880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.AppConfiguration/operations",
    validator: validate_OperationsList_567881, base: "", url: url_OperationsList_567882,
    schemes: {Scheme.Https})
type
  Call_OperationsCheckNameAvailability_568178 = ref object of OpenApiRestCall_567658
proc url_OperationsCheckNameAvailability_568180(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.AppConfiguration/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationsCheckNameAvailability_568179(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the configuration store name is available for use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568195 = path.getOrDefault("subscriptionId")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "subscriptionId", valid_568195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568196 = query.getOrDefault("api-version")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "api-version", valid_568196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   checkNameAvailabilityParameters: JObject (required)
  ##                                  : The object containing information for the availability request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568198: Call_OperationsCheckNameAvailability_568178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the configuration store name is available for use.
  ## 
  let valid = call_568198.validator(path, query, header, formData, body)
  let scheme = call_568198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568198.url(scheme.get, call_568198.host, call_568198.base,
                         call_568198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568198, url, valid)

proc call*(call_568199: Call_OperationsCheckNameAvailability_568178;
          checkNameAvailabilityParameters: JsonNode; apiVersion: string;
          subscriptionId: string): Recallable =
  ## operationsCheckNameAvailability
  ## Checks whether the configuration store name is available for use.
  ##   checkNameAvailabilityParameters: JObject (required)
  ##                                  : The object containing information for the availability request.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  var path_568200 = newJObject()
  var query_568201 = newJObject()
  var body_568202 = newJObject()
  if checkNameAvailabilityParameters != nil:
    body_568202 = checkNameAvailabilityParameters
  add(query_568201, "api-version", newJString(apiVersion))
  add(path_568200, "subscriptionId", newJString(subscriptionId))
  result = call_568199.call(path_568200, query_568201, nil, nil, body_568202)

var operationsCheckNameAvailability* = Call_OperationsCheckNameAvailability_568178(
    name: "operationsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AppConfiguration/checkNameAvailability",
    validator: validate_OperationsCheckNameAvailability_568179, base: "",
    url: url_OperationsCheckNameAvailability_568180, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresList_568203 = ref object of OpenApiRestCall_567658
proc url_ConfigurationStoresList_568205(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresList_568204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the configuration stores for a given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568206 = path.getOrDefault("subscriptionId")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "subscriptionId", valid_568206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  ##   $skipToken: JString
  ##             : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568207 = query.getOrDefault("api-version")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "api-version", valid_568207
  var valid_568208 = query.getOrDefault("$skipToken")
  valid_568208 = validateParameter(valid_568208, JString, required = false,
                                 default = nil)
  if valid_568208 != nil:
    section.add "$skipToken", valid_568208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568209: Call_ConfigurationStoresList_568203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the configuration stores for a given subscription.
  ## 
  let valid = call_568209.validator(path, query, header, formData, body)
  let scheme = call_568209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568209.url(scheme.get, call_568209.host, call_568209.base,
                         call_568209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568209, url, valid)

proc call*(call_568210: Call_ConfigurationStoresList_568203; apiVersion: string;
          subscriptionId: string; SkipToken: string = ""): Recallable =
  ## configurationStoresList
  ## Lists the configuration stores for a given subscription.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   SkipToken: string
  ##            : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  var path_568211 = newJObject()
  var query_568212 = newJObject()
  add(query_568212, "api-version", newJString(apiVersion))
  add(path_568211, "subscriptionId", newJString(subscriptionId))
  add(query_568212, "$skipToken", newJString(SkipToken))
  result = call_568210.call(path_568211, query_568212, nil, nil, nil)

var configurationStoresList* = Call_ConfigurationStoresList_568203(
    name: "configurationStoresList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AppConfiguration/configurationStores",
    validator: validate_ConfigurationStoresList_568204, base: "",
    url: url_ConfigurationStoresList_568205, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresListByResourceGroup_568213 = ref object of OpenApiRestCall_567658
proc url_ConfigurationStoresListByResourceGroup_568215(protocol: Scheme;
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
        value: "/providers/Microsoft.AppConfiguration/configurationStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresListByResourceGroup_568214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the configuration stores for a given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568216 = path.getOrDefault("resourceGroupName")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "resourceGroupName", valid_568216
  var valid_568217 = path.getOrDefault("subscriptionId")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "subscriptionId", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  ##   $skipToken: JString
  ##             : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "api-version", valid_568218
  var valid_568219 = query.getOrDefault("$skipToken")
  valid_568219 = validateParameter(valid_568219, JString, required = false,
                                 default = nil)
  if valid_568219 != nil:
    section.add "$skipToken", valid_568219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568220: Call_ConfigurationStoresListByResourceGroup_568213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the configuration stores for a given resource group.
  ## 
  let valid = call_568220.validator(path, query, header, formData, body)
  let scheme = call_568220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568220.url(scheme.get, call_568220.host, call_568220.base,
                         call_568220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568220, url, valid)

proc call*(call_568221: Call_ConfigurationStoresListByResourceGroup_568213;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          SkipToken: string = ""): Recallable =
  ## configurationStoresListByResourceGroup
  ## Lists the configuration stores for a given resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   SkipToken: string
  ##            : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  var path_568222 = newJObject()
  var query_568223 = newJObject()
  add(path_568222, "resourceGroupName", newJString(resourceGroupName))
  add(query_568223, "api-version", newJString(apiVersion))
  add(path_568222, "subscriptionId", newJString(subscriptionId))
  add(query_568223, "$skipToken", newJString(SkipToken))
  result = call_568221.call(path_568222, query_568223, nil, nil, nil)

var configurationStoresListByResourceGroup* = Call_ConfigurationStoresListByResourceGroup_568213(
    name: "configurationStoresListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores",
    validator: validate_ConfigurationStoresListByResourceGroup_568214, base: "",
    url: url_ConfigurationStoresListByResourceGroup_568215,
    schemes: {Scheme.Https})
type
  Call_ConfigurationStoresCreate_568235 = ref object of OpenApiRestCall_567658
proc url_ConfigurationStoresCreate_568237(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "configStoreName" in path, "`configStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores/"),
               (kind: VariableSegment, value: "configStoreName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresCreate_568236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a configuration store with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   configStoreName: JString (required)
  ##                  : The name of the configuration store.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568238 = path.getOrDefault("resourceGroupName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "resourceGroupName", valid_568238
  var valid_568239 = path.getOrDefault("subscriptionId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "subscriptionId", valid_568239
  var valid_568240 = path.getOrDefault("configStoreName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "configStoreName", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  ## parameters in `body` object:
  ##   configStoreCreationParameters: JObject (required)
  ##                                : The parameters for creating a configuration store.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568243: Call_ConfigurationStoresCreate_568235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a configuration store with the specified parameters.
  ## 
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_ConfigurationStoresCreate_568235;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          configStoreCreationParameters: JsonNode; configStoreName: string): Recallable =
  ## configurationStoresCreate
  ## Creates a configuration store with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   configStoreCreationParameters: JObject (required)
  ##                                : The parameters for creating a configuration store.
  ##   configStoreName: string (required)
  ##                  : The name of the configuration store.
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  var body_568247 = newJObject()
  add(path_568245, "resourceGroupName", newJString(resourceGroupName))
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "subscriptionId", newJString(subscriptionId))
  if configStoreCreationParameters != nil:
    body_568247 = configStoreCreationParameters
  add(path_568245, "configStoreName", newJString(configStoreName))
  result = call_568244.call(path_568245, query_568246, nil, nil, body_568247)

var configurationStoresCreate* = Call_ConfigurationStoresCreate_568235(
    name: "configurationStoresCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores/{configStoreName}",
    validator: validate_ConfigurationStoresCreate_568236, base: "",
    url: url_ConfigurationStoresCreate_568237, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresGet_568224 = ref object of OpenApiRestCall_567658
proc url_ConfigurationStoresGet_568226(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "configStoreName" in path, "`configStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores/"),
               (kind: VariableSegment, value: "configStoreName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresGet_568225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified configuration store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   configStoreName: JString (required)
  ##                  : The name of the configuration store.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568227 = path.getOrDefault("resourceGroupName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "resourceGroupName", valid_568227
  var valid_568228 = path.getOrDefault("subscriptionId")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "subscriptionId", valid_568228
  var valid_568229 = path.getOrDefault("configStoreName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "configStoreName", valid_568229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568230 = query.getOrDefault("api-version")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "api-version", valid_568230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568231: Call_ConfigurationStoresGet_568224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified configuration store.
  ## 
  let valid = call_568231.validator(path, query, header, formData, body)
  let scheme = call_568231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568231.url(scheme.get, call_568231.host, call_568231.base,
                         call_568231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568231, url, valid)

proc call*(call_568232: Call_ConfigurationStoresGet_568224;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          configStoreName: string): Recallable =
  ## configurationStoresGet
  ## Gets the properties of the specified configuration store.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   configStoreName: string (required)
  ##                  : The name of the configuration store.
  var path_568233 = newJObject()
  var query_568234 = newJObject()
  add(path_568233, "resourceGroupName", newJString(resourceGroupName))
  add(query_568234, "api-version", newJString(apiVersion))
  add(path_568233, "subscriptionId", newJString(subscriptionId))
  add(path_568233, "configStoreName", newJString(configStoreName))
  result = call_568232.call(path_568233, query_568234, nil, nil, nil)

var configurationStoresGet* = Call_ConfigurationStoresGet_568224(
    name: "configurationStoresGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores/{configStoreName}",
    validator: validate_ConfigurationStoresGet_568225, base: "",
    url: url_ConfigurationStoresGet_568226, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresUpdate_568259 = ref object of OpenApiRestCall_567658
proc url_ConfigurationStoresUpdate_568261(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "configStoreName" in path, "`configStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores/"),
               (kind: VariableSegment, value: "configStoreName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresUpdate_568260(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a configuration store with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   configStoreName: JString (required)
  ##                  : The name of the configuration store.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568262 = path.getOrDefault("resourceGroupName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "resourceGroupName", valid_568262
  var valid_568263 = path.getOrDefault("subscriptionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "subscriptionId", valid_568263
  var valid_568264 = path.getOrDefault("configStoreName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "configStoreName", valid_568264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  ##   configStoreUpdateParameters: JObject (required)
  ##                              : The parameters for updating a configuration store.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568267: Call_ConfigurationStoresUpdate_568259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a configuration store with the specified parameters.
  ## 
  let valid = call_568267.validator(path, query, header, formData, body)
  let scheme = call_568267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568267.url(scheme.get, call_568267.host, call_568267.base,
                         call_568267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568267, url, valid)

proc call*(call_568268: Call_ConfigurationStoresUpdate_568259;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          configStoreUpdateParameters: JsonNode; configStoreName: string): Recallable =
  ## configurationStoresUpdate
  ## Updates a configuration store with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   configStoreUpdateParameters: JObject (required)
  ##                              : The parameters for updating a configuration store.
  ##   configStoreName: string (required)
  ##                  : The name of the configuration store.
  var path_568269 = newJObject()
  var query_568270 = newJObject()
  var body_568271 = newJObject()
  add(path_568269, "resourceGroupName", newJString(resourceGroupName))
  add(query_568270, "api-version", newJString(apiVersion))
  add(path_568269, "subscriptionId", newJString(subscriptionId))
  if configStoreUpdateParameters != nil:
    body_568271 = configStoreUpdateParameters
  add(path_568269, "configStoreName", newJString(configStoreName))
  result = call_568268.call(path_568269, query_568270, nil, nil, body_568271)

var configurationStoresUpdate* = Call_ConfigurationStoresUpdate_568259(
    name: "configurationStoresUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores/{configStoreName}",
    validator: validate_ConfigurationStoresUpdate_568260, base: "",
    url: url_ConfigurationStoresUpdate_568261, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresDelete_568248 = ref object of OpenApiRestCall_567658
proc url_ConfigurationStoresDelete_568250(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "configStoreName" in path, "`configStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores/"),
               (kind: VariableSegment, value: "configStoreName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresDelete_568249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a configuration store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   configStoreName: JString (required)
  ##                  : The name of the configuration store.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568251 = path.getOrDefault("resourceGroupName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "resourceGroupName", valid_568251
  var valid_568252 = path.getOrDefault("subscriptionId")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "subscriptionId", valid_568252
  var valid_568253 = path.getOrDefault("configStoreName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "configStoreName", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_568255: Call_ConfigurationStoresDelete_568248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a configuration store.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_ConfigurationStoresDelete_568248;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          configStoreName: string): Recallable =
  ## configurationStoresDelete
  ## Deletes a configuration store.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   configStoreName: string (required)
  ##                  : The name of the configuration store.
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  add(path_568257, "resourceGroupName", newJString(resourceGroupName))
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  add(path_568257, "configStoreName", newJString(configStoreName))
  result = call_568256.call(path_568257, query_568258, nil, nil, nil)

var configurationStoresDelete* = Call_ConfigurationStoresDelete_568248(
    name: "configurationStoresDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores/{configStoreName}",
    validator: validate_ConfigurationStoresDelete_568249, base: "",
    url: url_ConfigurationStoresDelete_568250, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresListKeys_568272 = ref object of OpenApiRestCall_567658
proc url_ConfigurationStoresListKeys_568274(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "configStoreName" in path, "`configStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores/"),
               (kind: VariableSegment, value: "configStoreName"),
               (kind: ConstantSegment, value: "/ListKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresListKeys_568273(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the access key for the specified configuration store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   configStoreName: JString (required)
  ##                  : The name of the configuration store.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568275 = path.getOrDefault("resourceGroupName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "resourceGroupName", valid_568275
  var valid_568276 = path.getOrDefault("subscriptionId")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "subscriptionId", valid_568276
  var valid_568277 = path.getOrDefault("configStoreName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "configStoreName", valid_568277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  ##   $skipToken: JString
  ##             : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568278 = query.getOrDefault("api-version")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "api-version", valid_568278
  var valid_568279 = query.getOrDefault("$skipToken")
  valid_568279 = validateParameter(valid_568279, JString, required = false,
                                 default = nil)
  if valid_568279 != nil:
    section.add "$skipToken", valid_568279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568280: Call_ConfigurationStoresListKeys_568272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the access key for the specified configuration store.
  ## 
  let valid = call_568280.validator(path, query, header, formData, body)
  let scheme = call_568280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568280.url(scheme.get, call_568280.host, call_568280.base,
                         call_568280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568280, url, valid)

proc call*(call_568281: Call_ConfigurationStoresListKeys_568272;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          configStoreName: string; SkipToken: string = ""): Recallable =
  ## configurationStoresListKeys
  ## Lists the access key for the specified configuration store.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   configStoreName: string (required)
  ##                  : The name of the configuration store.
  ##   SkipToken: string
  ##            : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  var path_568282 = newJObject()
  var query_568283 = newJObject()
  add(path_568282, "resourceGroupName", newJString(resourceGroupName))
  add(query_568283, "api-version", newJString(apiVersion))
  add(path_568282, "subscriptionId", newJString(subscriptionId))
  add(path_568282, "configStoreName", newJString(configStoreName))
  add(query_568283, "$skipToken", newJString(SkipToken))
  result = call_568281.call(path_568282, query_568283, nil, nil, nil)

var configurationStoresListKeys* = Call_ConfigurationStoresListKeys_568272(
    name: "configurationStoresListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores/{configStoreName}/ListKeys",
    validator: validate_ConfigurationStoresListKeys_568273, base: "",
    url: url_ConfigurationStoresListKeys_568274, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresRegenerateKey_568284 = ref object of OpenApiRestCall_567658
proc url_ConfigurationStoresRegenerateKey_568286(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "configStoreName" in path, "`configStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores/"),
               (kind: VariableSegment, value: "configStoreName"),
               (kind: ConstantSegment, value: "/RegenerateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresRegenerateKey_568285(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates an access key for the specified configuration store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   configStoreName: JString (required)
  ##                  : The name of the configuration store.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568287 = path.getOrDefault("resourceGroupName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "resourceGroupName", valid_568287
  var valid_568288 = path.getOrDefault("subscriptionId")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "subscriptionId", valid_568288
  var valid_568289 = path.getOrDefault("configStoreName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "configStoreName", valid_568289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568290 = query.getOrDefault("api-version")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "api-version", valid_568290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regenerateKeyParameters: JObject (required)
  ##                          : The parameters for regenerating an access key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568292: Call_ConfigurationStoresRegenerateKey_568284;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates an access key for the specified configuration store.
  ## 
  let valid = call_568292.validator(path, query, header, formData, body)
  let scheme = call_568292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568292.url(scheme.get, call_568292.host, call_568292.base,
                         call_568292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568292, url, valid)

proc call*(call_568293: Call_ConfigurationStoresRegenerateKey_568284;
          resourceGroupName: string; apiVersion: string;
          regenerateKeyParameters: JsonNode; subscriptionId: string;
          configStoreName: string): Recallable =
  ## configurationStoresRegenerateKey
  ## Regenerates an access key for the specified configuration store.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   regenerateKeyParameters: JObject (required)
  ##                          : The parameters for regenerating an access key.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   configStoreName: string (required)
  ##                  : The name of the configuration store.
  var path_568294 = newJObject()
  var query_568295 = newJObject()
  var body_568296 = newJObject()
  add(path_568294, "resourceGroupName", newJString(resourceGroupName))
  add(query_568295, "api-version", newJString(apiVersion))
  if regenerateKeyParameters != nil:
    body_568296 = regenerateKeyParameters
  add(path_568294, "subscriptionId", newJString(subscriptionId))
  add(path_568294, "configStoreName", newJString(configStoreName))
  result = call_568293.call(path_568294, query_568295, nil, nil, body_568296)

var configurationStoresRegenerateKey* = Call_ConfigurationStoresRegenerateKey_568284(
    name: "configurationStoresRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores/{configStoreName}/RegenerateKey",
    validator: validate_ConfigurationStoresRegenerateKey_568285, base: "",
    url: url_ConfigurationStoresRegenerateKey_568286, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresListKeyValue_568297 = ref object of OpenApiRestCall_567658
proc url_ConfigurationStoresListKeyValue_568299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "configStoreName" in path, "`configStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores/"),
               (kind: VariableSegment, value: "configStoreName"),
               (kind: ConstantSegment, value: "/listKeyValue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresListKeyValue_568298(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a configuration store key-value.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   configStoreName: JString (required)
  ##                  : The name of the configuration store.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568300 = path.getOrDefault("resourceGroupName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "resourceGroupName", valid_568300
  var valid_568301 = path.getOrDefault("subscriptionId")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "subscriptionId", valid_568301
  var valid_568302 = path.getOrDefault("configStoreName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "configStoreName", valid_568302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  ## parameters in `body` object:
  ##   listKeyValueParameters: JObject (required)
  ##                         : The parameters for retrieving a key-value.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568305: Call_ConfigurationStoresListKeyValue_568297;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a configuration store key-value.
  ## 
  let valid = call_568305.validator(path, query, header, formData, body)
  let scheme = call_568305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568305.url(scheme.get, call_568305.host, call_568305.base,
                         call_568305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568305, url, valid)

proc call*(call_568306: Call_ConfigurationStoresListKeyValue_568297;
          resourceGroupName: string; listKeyValueParameters: JsonNode;
          apiVersion: string; subscriptionId: string; configStoreName: string): Recallable =
  ## configurationStoresListKeyValue
  ## Lists a configuration store key-value.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   listKeyValueParameters: JObject (required)
  ##                         : The parameters for retrieving a key-value.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   configStoreName: string (required)
  ##                  : The name of the configuration store.
  var path_568307 = newJObject()
  var query_568308 = newJObject()
  var body_568309 = newJObject()
  add(path_568307, "resourceGroupName", newJString(resourceGroupName))
  if listKeyValueParameters != nil:
    body_568309 = listKeyValueParameters
  add(query_568308, "api-version", newJString(apiVersion))
  add(path_568307, "subscriptionId", newJString(subscriptionId))
  add(path_568307, "configStoreName", newJString(configStoreName))
  result = call_568306.call(path_568307, query_568308, nil, nil, body_568309)

var configurationStoresListKeyValue* = Call_ConfigurationStoresListKeyValue_568297(
    name: "configurationStoresListKeyValue", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores/{configStoreName}/listKeyValue",
    validator: validate_ConfigurationStoresListKeyValue_568298, base: "",
    url: url_ConfigurationStoresListKeyValue_568299, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
