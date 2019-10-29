
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure ML Web Services Management Client
## version: 2017-01-01
## termsOfService: (not provided)
## license: (not provided)
## 
## These APIs allow end users to operate on Azure Machine Learning Web Services resources. They support the following operations:<ul><li>Create or update a web service</li><li>Get a web service</li><li>Patch a web service</li><li>Delete a web service</li><li>Get All Web Services in a Resource Group </li><li>Get All Web Services in a Subscription</li><li>Get Web Services Keys</li></ul>
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "machinelearning-webservices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563778 = ref object of OpenApiRestCall_563556
proc url_OperationsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563779(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the available REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "api-version", valid_563941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available REST API operations.
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_OperationsList_563778; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all the available REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MachineLearning/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_WebServicesListBySubscriptionId_564076 = ref object of OpenApiRestCall_563556
proc url_WebServicesListBySubscriptionId_564078(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.MachineLearning/webServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebServicesListBySubscriptionId_564077(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the web services in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564094 = path.getOrDefault("subscriptionId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "subscriptionId", valid_564094
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564095 = query.getOrDefault("api-version")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "api-version", valid_564095
  var valid_564096 = query.getOrDefault("$skiptoken")
  valid_564096 = validateParameter(valid_564096, JString, required = false,
                                 default = nil)
  if valid_564096 != nil:
    section.add "$skiptoken", valid_564096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564097: Call_WebServicesListBySubscriptionId_564076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the web services in the specified subscription.
  ## 
  let valid = call_564097.validator(path, query, header, formData, body)
  let scheme = call_564097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564097.url(scheme.get, call_564097.host, call_564097.base,
                         call_564097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564097, url, valid)

proc call*(call_564098: Call_WebServicesListBySubscriptionId_564076;
          apiVersion: string; subscriptionId: string; Skiptoken: string = ""): Recallable =
  ## webServicesListBySubscriptionId
  ## Gets the web services in the specified subscription.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  var path_564099 = newJObject()
  var query_564100 = newJObject()
  add(query_564100, "api-version", newJString(apiVersion))
  add(path_564099, "subscriptionId", newJString(subscriptionId))
  add(query_564100, "$skiptoken", newJString(Skiptoken))
  result = call_564098.call(path_564099, query_564100, nil, nil, nil)

var webServicesListBySubscriptionId* = Call_WebServicesListBySubscriptionId_564076(
    name: "webServicesListBySubscriptionId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearning/webServices",
    validator: validate_WebServicesListBySubscriptionId_564077, base: "",
    url: url_WebServicesListBySubscriptionId_564078, schemes: {Scheme.Https})
type
  Call_WebServicesListByResourceGroup_564101 = ref object of OpenApiRestCall_563556
proc url_WebServicesListByResourceGroup_564103(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.MachineLearning/webServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebServicesListByResourceGroup_564102(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the web services in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the web service is located.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564104 = path.getOrDefault("subscriptionId")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "subscriptionId", valid_564104
  var valid_564105 = path.getOrDefault("resourceGroupName")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "resourceGroupName", valid_564105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564106 = query.getOrDefault("api-version")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "api-version", valid_564106
  var valid_564107 = query.getOrDefault("$skiptoken")
  valid_564107 = validateParameter(valid_564107, JString, required = false,
                                 default = nil)
  if valid_564107 != nil:
    section.add "$skiptoken", valid_564107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_WebServicesListByResourceGroup_564101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the web services in the specified resource group.
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_WebServicesListByResourceGroup_564101;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Skiptoken: string = ""): Recallable =
  ## webServicesListByResourceGroup
  ## Gets the web services in the specified resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the web service is located.
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  add(path_564110, "subscriptionId", newJString(subscriptionId))
  add(query_564111, "$skiptoken", newJString(Skiptoken))
  add(path_564110, "resourceGroupName", newJString(resourceGroupName))
  result = call_564109.call(path_564110, query_564111, nil, nil, nil)

var webServicesListByResourceGroup* = Call_WebServicesListByResourceGroup_564101(
    name: "webServicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/webServices",
    validator: validate_WebServicesListByResourceGroup_564102, base: "",
    url: url_WebServicesListByResourceGroup_564103, schemes: {Scheme.Https})
type
  Call_WebServicesCreateOrUpdate_564124 = ref object of OpenApiRestCall_563556
proc url_WebServicesCreateOrUpdate_564126(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "webServiceName" in path, "`webServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/webServices/"),
               (kind: VariableSegment, value: "webServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebServicesCreateOrUpdate_564125(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a web service. This call will overwrite an existing web service. Note that there is no warning or confirmation. This is a nonrecoverable operation. If your intent is to create a new web service, call the Get operation first to verify that it does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webServiceName: JString (required)
  ##                 : The name of the web service.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the web service is located.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webServiceName` field"
  var valid_564127 = path.getOrDefault("webServiceName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "webServiceName", valid_564127
  var valid_564128 = path.getOrDefault("subscriptionId")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "subscriptionId", valid_564128
  var valid_564129 = path.getOrDefault("resourceGroupName")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "resourceGroupName", valid_564129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564130 = query.getOrDefault("api-version")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "api-version", valid_564130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createOrUpdatePayload: JObject (required)
  ##                        : The payload that is used to create or update the web service.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564132: Call_WebServicesCreateOrUpdate_564124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a web service. This call will overwrite an existing web service. Note that there is no warning or confirmation. This is a nonrecoverable operation. If your intent is to create a new web service, call the Get operation first to verify that it does not exist.
  ## 
  let valid = call_564132.validator(path, query, header, formData, body)
  let scheme = call_564132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564132.url(scheme.get, call_564132.host, call_564132.base,
                         call_564132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564132, url, valid)

proc call*(call_564133: Call_WebServicesCreateOrUpdate_564124;
          webServiceName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; createOrUpdatePayload: JsonNode): Recallable =
  ## webServicesCreateOrUpdate
  ## Create or update a web service. This call will overwrite an existing web service. Note that there is no warning or confirmation. This is a nonrecoverable operation. If your intent is to create a new web service, call the Get operation first to verify that it does not exist.
  ##   webServiceName: string (required)
  ##                 : The name of the web service.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   createOrUpdatePayload: JObject (required)
  ##                        : The payload that is used to create or update the web service.
  var path_564134 = newJObject()
  var query_564135 = newJObject()
  var body_564136 = newJObject()
  add(path_564134, "webServiceName", newJString(webServiceName))
  add(query_564135, "api-version", newJString(apiVersion))
  add(path_564134, "subscriptionId", newJString(subscriptionId))
  add(path_564134, "resourceGroupName", newJString(resourceGroupName))
  if createOrUpdatePayload != nil:
    body_564136 = createOrUpdatePayload
  result = call_564133.call(path_564134, query_564135, nil, nil, body_564136)

var webServicesCreateOrUpdate* = Call_WebServicesCreateOrUpdate_564124(
    name: "webServicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/webServices/{webServiceName}",
    validator: validate_WebServicesCreateOrUpdate_564125, base: "",
    url: url_WebServicesCreateOrUpdate_564126, schemes: {Scheme.Https})
type
  Call_WebServicesGet_564112 = ref object of OpenApiRestCall_563556
proc url_WebServicesGet_564114(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "webServiceName" in path, "`webServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/webServices/"),
               (kind: VariableSegment, value: "webServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebServicesGet_564113(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the Web Service Definition as specified by a subscription, resource group, and name. Note that the storage credentials and web service keys are not returned by this call. To get the web service access keys, call List Keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webServiceName: JString (required)
  ##                 : The name of the web service.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the web service is located.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webServiceName` field"
  var valid_564115 = path.getOrDefault("webServiceName")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "webServiceName", valid_564115
  var valid_564116 = path.getOrDefault("subscriptionId")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "subscriptionId", valid_564116
  var valid_564117 = path.getOrDefault("resourceGroupName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "resourceGroupName", valid_564117
  result.add "path", section
  ## parameters in `query` object:
  ##   region: JString
  ##         : The region for which encrypted credential parameters are valid.
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  var valid_564118 = query.getOrDefault("region")
  valid_564118 = validateParameter(valid_564118, JString, required = false,
                                 default = nil)
  if valid_564118 != nil:
    section.add "region", valid_564118
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564120: Call_WebServicesGet_564112; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Web Service Definition as specified by a subscription, resource group, and name. Note that the storage credentials and web service keys are not returned by this call. To get the web service access keys, call List Keys.
  ## 
  let valid = call_564120.validator(path, query, header, formData, body)
  let scheme = call_564120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564120.url(scheme.get, call_564120.host, call_564120.base,
                         call_564120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564120, url, valid)

proc call*(call_564121: Call_WebServicesGet_564112; webServiceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          region: string = ""): Recallable =
  ## webServicesGet
  ## Gets the Web Service Definition as specified by a subscription, resource group, and name. Note that the storage credentials and web service keys are not returned by this call. To get the web service access keys, call List Keys.
  ##   region: string
  ##         : The region for which encrypted credential parameters are valid.
  ##   webServiceName: string (required)
  ##                 : The name of the web service.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the web service is located.
  var path_564122 = newJObject()
  var query_564123 = newJObject()
  add(query_564123, "region", newJString(region))
  add(path_564122, "webServiceName", newJString(webServiceName))
  add(query_564123, "api-version", newJString(apiVersion))
  add(path_564122, "subscriptionId", newJString(subscriptionId))
  add(path_564122, "resourceGroupName", newJString(resourceGroupName))
  result = call_564121.call(path_564122, query_564123, nil, nil, nil)

var webServicesGet* = Call_WebServicesGet_564112(name: "webServicesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/webServices/{webServiceName}",
    validator: validate_WebServicesGet_564113, base: "", url: url_WebServicesGet_564114,
    schemes: {Scheme.Https})
type
  Call_WebServicesPatch_564148 = ref object of OpenApiRestCall_563556
proc url_WebServicesPatch_564150(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "webServiceName" in path, "`webServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/webServices/"),
               (kind: VariableSegment, value: "webServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebServicesPatch_564149(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Modifies an existing web service resource. The PATCH API call is an asynchronous operation. To determine whether it has completed successfully, you must perform a Get operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webServiceName: JString (required)
  ##                 : The name of the web service.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the web service is located.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webServiceName` field"
  var valid_564151 = path.getOrDefault("webServiceName")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "webServiceName", valid_564151
  var valid_564152 = path.getOrDefault("subscriptionId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "subscriptionId", valid_564152
  var valid_564153 = path.getOrDefault("resourceGroupName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "resourceGroupName", valid_564153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564154 = query.getOrDefault("api-version")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "api-version", valid_564154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patchPayload: JObject (required)
  ##               : The payload to use to patch the web service.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_WebServicesPatch_564148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies an existing web service resource. The PATCH API call is an asynchronous operation. To determine whether it has completed successfully, you must perform a Get operation.
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_WebServicesPatch_564148; webServiceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          patchPayload: JsonNode): Recallable =
  ## webServicesPatch
  ## Modifies an existing web service resource. The PATCH API call is an asynchronous operation. To determine whether it has completed successfully, you must perform a Get operation.
  ##   webServiceName: string (required)
  ##                 : The name of the web service.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   patchPayload: JObject (required)
  ##               : The payload to use to patch the web service.
  var path_564158 = newJObject()
  var query_564159 = newJObject()
  var body_564160 = newJObject()
  add(path_564158, "webServiceName", newJString(webServiceName))
  add(query_564159, "api-version", newJString(apiVersion))
  add(path_564158, "subscriptionId", newJString(subscriptionId))
  add(path_564158, "resourceGroupName", newJString(resourceGroupName))
  if patchPayload != nil:
    body_564160 = patchPayload
  result = call_564157.call(path_564158, query_564159, nil, nil, body_564160)

var webServicesPatch* = Call_WebServicesPatch_564148(name: "webServicesPatch",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/webServices/{webServiceName}",
    validator: validate_WebServicesPatch_564149, base: "",
    url: url_WebServicesPatch_564150, schemes: {Scheme.Https})
type
  Call_WebServicesRemove_564137 = ref object of OpenApiRestCall_563556
proc url_WebServicesRemove_564139(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "webServiceName" in path, "`webServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/webServices/"),
               (kind: VariableSegment, value: "webServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebServicesRemove_564138(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the specified web service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webServiceName: JString (required)
  ##                 : The name of the web service.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the web service is located.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webServiceName` field"
  var valid_564140 = path.getOrDefault("webServiceName")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "webServiceName", valid_564140
  var valid_564141 = path.getOrDefault("subscriptionId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "subscriptionId", valid_564141
  var valid_564142 = path.getOrDefault("resourceGroupName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "resourceGroupName", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_WebServicesRemove_564137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified web service.
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_WebServicesRemove_564137; webServiceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## webServicesRemove
  ## Deletes the specified web service.
  ##   webServiceName: string (required)
  ##                 : The name of the web service.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the web service is located.
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  add(path_564146, "webServiceName", newJString(webServiceName))
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  add(path_564146, "resourceGroupName", newJString(resourceGroupName))
  result = call_564145.call(path_564146, query_564147, nil, nil, nil)

var webServicesRemove* = Call_WebServicesRemove_564137(name: "webServicesRemove",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/webServices/{webServiceName}",
    validator: validate_WebServicesRemove_564138, base: "",
    url: url_WebServicesRemove_564139, schemes: {Scheme.Https})
type
  Call_WebServicesCreateRegionalProperties_564161 = ref object of OpenApiRestCall_563556
proc url_WebServicesCreateRegionalProperties_564163(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "webServiceName" in path, "`webServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/webServices/"),
               (kind: VariableSegment, value: "webServiceName"),
               (kind: ConstantSegment, value: "/CreateRegionalBlob")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebServicesCreateRegionalProperties_564162(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an encrypted credentials parameter blob for the specified region. To get the web service from a region other than the region in which it has been created, you must first call Create Regional Web Services Properties to create a copy of the encrypted credential parameter blob in that region. You only need to do this before the first time that you get the web service in the new region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webServiceName: JString (required)
  ##                 : The name of the web service.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the web service is located.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webServiceName` field"
  var valid_564164 = path.getOrDefault("webServiceName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "webServiceName", valid_564164
  var valid_564165 = path.getOrDefault("subscriptionId")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "subscriptionId", valid_564165
  var valid_564166 = path.getOrDefault("resourceGroupName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "resourceGroupName", valid_564166
  result.add "path", section
  ## parameters in `query` object:
  ##   region: JString (required)
  ##         : The region for which encrypted credential parameters are created.
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `region` field"
  var valid_564167 = query.getOrDefault("region")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "region", valid_564167
  var valid_564168 = query.getOrDefault("api-version")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "api-version", valid_564168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564169: Call_WebServicesCreateRegionalProperties_564161;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an encrypted credentials parameter blob for the specified region. To get the web service from a region other than the region in which it has been created, you must first call Create Regional Web Services Properties to create a copy of the encrypted credential parameter blob in that region. You only need to do this before the first time that you get the web service in the new region.
  ## 
  let valid = call_564169.validator(path, query, header, formData, body)
  let scheme = call_564169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564169.url(scheme.get, call_564169.host, call_564169.base,
                         call_564169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564169, url, valid)

proc call*(call_564170: Call_WebServicesCreateRegionalProperties_564161;
          region: string; webServiceName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## webServicesCreateRegionalProperties
  ## Creates an encrypted credentials parameter blob for the specified region. To get the web service from a region other than the region in which it has been created, you must first call Create Regional Web Services Properties to create a copy of the encrypted credential parameter blob in that region. You only need to do this before the first time that you get the web service in the new region.
  ##   region: string (required)
  ##         : The region for which encrypted credential parameters are created.
  ##   webServiceName: string (required)
  ##                 : The name of the web service.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the web service is located.
  var path_564171 = newJObject()
  var query_564172 = newJObject()
  add(query_564172, "region", newJString(region))
  add(path_564171, "webServiceName", newJString(webServiceName))
  add(query_564172, "api-version", newJString(apiVersion))
  add(path_564171, "subscriptionId", newJString(subscriptionId))
  add(path_564171, "resourceGroupName", newJString(resourceGroupName))
  result = call_564170.call(path_564171, query_564172, nil, nil, nil)

var webServicesCreateRegionalProperties* = Call_WebServicesCreateRegionalProperties_564161(
    name: "webServicesCreateRegionalProperties", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/webServices/{webServiceName}/CreateRegionalBlob",
    validator: validate_WebServicesCreateRegionalProperties_564162, base: "",
    url: url_WebServicesCreateRegionalProperties_564163, schemes: {Scheme.Https})
type
  Call_WebServicesListKeys_564173 = ref object of OpenApiRestCall_563556
proc url_WebServicesListKeys_564175(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "webServiceName" in path, "`webServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearning/webServices/"),
               (kind: VariableSegment, value: "webServiceName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebServicesListKeys_564174(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the access keys for the specified web service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webServiceName: JString (required)
  ##                 : The name of the web service.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the web service is located.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webServiceName` field"
  var valid_564176 = path.getOrDefault("webServiceName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "webServiceName", valid_564176
  var valid_564177 = path.getOrDefault("subscriptionId")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "subscriptionId", valid_564177
  var valid_564178 = path.getOrDefault("resourceGroupName")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "resourceGroupName", valid_564178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564179 = query.getOrDefault("api-version")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "api-version", valid_564179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564180: Call_WebServicesListKeys_564173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access keys for the specified web service.
  ## 
  let valid = call_564180.validator(path, query, header, formData, body)
  let scheme = call_564180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564180.url(scheme.get, call_564180.host, call_564180.base,
                         call_564180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564180, url, valid)

proc call*(call_564181: Call_WebServicesListKeys_564173; webServiceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## webServicesListKeys
  ## Gets the access keys for the specified web service.
  ##   webServiceName: string (required)
  ##                 : The name of the web service.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the web service is located.
  var path_564182 = newJObject()
  var query_564183 = newJObject()
  add(path_564182, "webServiceName", newJString(webServiceName))
  add(query_564183, "api-version", newJString(apiVersion))
  add(path_564182, "subscriptionId", newJString(subscriptionId))
  add(path_564182, "resourceGroupName", newJString(resourceGroupName))
  result = call_564181.call(path_564182, query_564183, nil, nil, nil)

var webServicesListKeys* = Call_WebServicesListKeys_564173(
    name: "webServicesListKeys", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/webServices/{webServiceName}/listKeys",
    validator: validate_WebServicesListKeys_564174, base: "",
    url: url_WebServicesListKeys_564175, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
