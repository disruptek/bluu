
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  macServiceName = "machinelearning-webservices"
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
  var valid_568041 = query.getOrDefault("api-version")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "api-version", valid_568041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_OperationsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available REST API operations.
  ## 
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_OperationsList_567880; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all the available REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  result = call_568135.call(nil, query_568136, nil, nil, nil)

var operationsList* = Call_OperationsList_567880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MachineLearning/operations",
    validator: validate_OperationsList_567881, base: "", url: url_OperationsList_567882,
    schemes: {Scheme.Https})
type
  Call_WebServicesListBySubscriptionId_568176 = ref object of OpenApiRestCall_567658
proc url_WebServicesListBySubscriptionId_568178(protocol: Scheme; host: string;
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

proc validate_WebServicesListBySubscriptionId_568177(path: JsonNode;
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
  var valid_568194 = path.getOrDefault("subscriptionId")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "subscriptionId", valid_568194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568195 = query.getOrDefault("api-version")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "api-version", valid_568195
  var valid_568196 = query.getOrDefault("$skiptoken")
  valid_568196 = validateParameter(valid_568196, JString, required = false,
                                 default = nil)
  if valid_568196 != nil:
    section.add "$skiptoken", valid_568196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568197: Call_WebServicesListBySubscriptionId_568176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the web services in the specified subscription.
  ## 
  let valid = call_568197.validator(path, query, header, formData, body)
  let scheme = call_568197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568197.url(scheme.get, call_568197.host, call_568197.base,
                         call_568197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568197, url, valid)

proc call*(call_568198: Call_WebServicesListBySubscriptionId_568176;
          apiVersion: string; subscriptionId: string; Skiptoken: string = ""): Recallable =
  ## webServicesListBySubscriptionId
  ## Gets the web services in the specified subscription.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  var path_568199 = newJObject()
  var query_568200 = newJObject()
  add(query_568200, "api-version", newJString(apiVersion))
  add(path_568199, "subscriptionId", newJString(subscriptionId))
  add(query_568200, "$skiptoken", newJString(Skiptoken))
  result = call_568198.call(path_568199, query_568200, nil, nil, nil)

var webServicesListBySubscriptionId* = Call_WebServicesListBySubscriptionId_568176(
    name: "webServicesListBySubscriptionId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearning/webServices",
    validator: validate_WebServicesListBySubscriptionId_568177, base: "",
    url: url_WebServicesListBySubscriptionId_568178, schemes: {Scheme.Https})
type
  Call_WebServicesListByResourceGroup_568201 = ref object of OpenApiRestCall_567658
proc url_WebServicesListByResourceGroup_568203(protocol: Scheme; host: string;
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

proc validate_WebServicesListByResourceGroup_568202(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the web services in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568204 = path.getOrDefault("resourceGroupName")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "resourceGroupName", valid_568204
  var valid_568205 = path.getOrDefault("subscriptionId")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "subscriptionId", valid_568205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  var valid_568207 = query.getOrDefault("$skiptoken")
  valid_568207 = validateParameter(valid_568207, JString, required = false,
                                 default = nil)
  if valid_568207 != nil:
    section.add "$skiptoken", valid_568207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_WebServicesListByResourceGroup_568201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the web services in the specified resource group.
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_WebServicesListByResourceGroup_568201;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Skiptoken: string = ""): Recallable =
  ## webServicesListByResourceGroup
  ## Gets the web services in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  var path_568210 = newJObject()
  var query_568211 = newJObject()
  add(path_568210, "resourceGroupName", newJString(resourceGroupName))
  add(query_568211, "api-version", newJString(apiVersion))
  add(path_568210, "subscriptionId", newJString(subscriptionId))
  add(query_568211, "$skiptoken", newJString(Skiptoken))
  result = call_568209.call(path_568210, query_568211, nil, nil, nil)

var webServicesListByResourceGroup* = Call_WebServicesListByResourceGroup_568201(
    name: "webServicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/webServices",
    validator: validate_WebServicesListByResourceGroup_568202, base: "",
    url: url_WebServicesListByResourceGroup_568203, schemes: {Scheme.Https})
type
  Call_WebServicesCreateOrUpdate_568224 = ref object of OpenApiRestCall_567658
proc url_WebServicesCreateOrUpdate_568226(protocol: Scheme; host: string;
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

proc validate_WebServicesCreateOrUpdate_568225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a web service. This call will overwrite an existing web service. Note that there is no warning or confirmation. This is a nonrecoverable operation. If your intent is to create a new web service, call the Get operation first to verify that it does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   webServiceName: JString (required)
  ##                 : The name of the web service.
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
  var valid_568229 = path.getOrDefault("webServiceName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "webServiceName", valid_568229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
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
  ## parameters in `body` object:
  ##   createOrUpdatePayload: JObject (required)
  ##                        : The payload that is used to create or update the web service.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568232: Call_WebServicesCreateOrUpdate_568224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a web service. This call will overwrite an existing web service. Note that there is no warning or confirmation. This is a nonrecoverable operation. If your intent is to create a new web service, call the Get operation first to verify that it does not exist.
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_WebServicesCreateOrUpdate_568224;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          webServiceName: string; createOrUpdatePayload: JsonNode): Recallable =
  ## webServicesCreateOrUpdate
  ## Create or update a web service. This call will overwrite an existing web service. Note that there is no warning or confirmation. This is a nonrecoverable operation. If your intent is to create a new web service, call the Get operation first to verify that it does not exist.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   webServiceName: string (required)
  ##                 : The name of the web service.
  ##   createOrUpdatePayload: JObject (required)
  ##                        : The payload that is used to create or update the web service.
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  var body_568236 = newJObject()
  add(path_568234, "resourceGroupName", newJString(resourceGroupName))
  add(query_568235, "api-version", newJString(apiVersion))
  add(path_568234, "subscriptionId", newJString(subscriptionId))
  add(path_568234, "webServiceName", newJString(webServiceName))
  if createOrUpdatePayload != nil:
    body_568236 = createOrUpdatePayload
  result = call_568233.call(path_568234, query_568235, nil, nil, body_568236)

var webServicesCreateOrUpdate* = Call_WebServicesCreateOrUpdate_568224(
    name: "webServicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/webServices/{webServiceName}",
    validator: validate_WebServicesCreateOrUpdate_568225, base: "",
    url: url_WebServicesCreateOrUpdate_568226, schemes: {Scheme.Https})
type
  Call_WebServicesGet_568212 = ref object of OpenApiRestCall_567658
proc url_WebServicesGet_568214(protocol: Scheme; host: string; base: string;
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

proc validate_WebServicesGet_568213(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the Web Service Definition as specified by a subscription, resource group, and name. Note that the storage credentials and web service keys are not returned by this call. To get the web service access keys, call List Keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   webServiceName: JString (required)
  ##                 : The name of the web service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568215 = path.getOrDefault("resourceGroupName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "resourceGroupName", valid_568215
  var valid_568216 = path.getOrDefault("subscriptionId")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "subscriptionId", valid_568216
  var valid_568217 = path.getOrDefault("webServiceName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "webServiceName", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   region: JString
  ##         : The region for which encrypted credential parameters are valid.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "api-version", valid_568218
  var valid_568219 = query.getOrDefault("region")
  valid_568219 = validateParameter(valid_568219, JString, required = false,
                                 default = nil)
  if valid_568219 != nil:
    section.add "region", valid_568219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568220: Call_WebServicesGet_568212; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Web Service Definition as specified by a subscription, resource group, and name. Note that the storage credentials and web service keys are not returned by this call. To get the web service access keys, call List Keys.
  ## 
  let valid = call_568220.validator(path, query, header, formData, body)
  let scheme = call_568220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568220.url(scheme.get, call_568220.host, call_568220.base,
                         call_568220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568220, url, valid)

proc call*(call_568221: Call_WebServicesGet_568212; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; webServiceName: string;
          region: string = ""): Recallable =
  ## webServicesGet
  ## Gets the Web Service Definition as specified by a subscription, resource group, and name. Note that the storage credentials and web service keys are not returned by this call. To get the web service access keys, call List Keys.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   webServiceName: string (required)
  ##                 : The name of the web service.
  ##   region: string
  ##         : The region for which encrypted credential parameters are valid.
  var path_568222 = newJObject()
  var query_568223 = newJObject()
  add(path_568222, "resourceGroupName", newJString(resourceGroupName))
  add(query_568223, "api-version", newJString(apiVersion))
  add(path_568222, "subscriptionId", newJString(subscriptionId))
  add(path_568222, "webServiceName", newJString(webServiceName))
  add(query_568223, "region", newJString(region))
  result = call_568221.call(path_568222, query_568223, nil, nil, nil)

var webServicesGet* = Call_WebServicesGet_568212(name: "webServicesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/webServices/{webServiceName}",
    validator: validate_WebServicesGet_568213, base: "", url: url_WebServicesGet_568214,
    schemes: {Scheme.Https})
type
  Call_WebServicesPatch_568248 = ref object of OpenApiRestCall_567658
proc url_WebServicesPatch_568250(protocol: Scheme; host: string; base: string;
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

proc validate_WebServicesPatch_568249(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Modifies an existing web service resource. The PATCH API call is an asynchronous operation. To determine whether it has completed successfully, you must perform a Get operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   webServiceName: JString (required)
  ##                 : The name of the web service.
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
  var valid_568253 = path.getOrDefault("webServiceName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "webServiceName", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
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
  ## parameters in `body` object:
  ##   patchPayload: JObject (required)
  ##               : The payload to use to patch the web service.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568256: Call_WebServicesPatch_568248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies an existing web service resource. The PATCH API call is an asynchronous operation. To determine whether it has completed successfully, you must perform a Get operation.
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_WebServicesPatch_568248; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; webServiceName: string;
          patchPayload: JsonNode): Recallable =
  ## webServicesPatch
  ## Modifies an existing web service resource. The PATCH API call is an asynchronous operation. To determine whether it has completed successfully, you must perform a Get operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   webServiceName: string (required)
  ##                 : The name of the web service.
  ##   patchPayload: JObject (required)
  ##               : The payload to use to patch the web service.
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  var body_568260 = newJObject()
  add(path_568258, "resourceGroupName", newJString(resourceGroupName))
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "subscriptionId", newJString(subscriptionId))
  add(path_568258, "webServiceName", newJString(webServiceName))
  if patchPayload != nil:
    body_568260 = patchPayload
  result = call_568257.call(path_568258, query_568259, nil, nil, body_568260)

var webServicesPatch* = Call_WebServicesPatch_568248(name: "webServicesPatch",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/webServices/{webServiceName}",
    validator: validate_WebServicesPatch_568249, base: "",
    url: url_WebServicesPatch_568250, schemes: {Scheme.Https})
type
  Call_WebServicesRemove_568237 = ref object of OpenApiRestCall_567658
proc url_WebServicesRemove_568239(protocol: Scheme; host: string; base: string;
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

proc validate_WebServicesRemove_568238(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the specified web service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   webServiceName: JString (required)
  ##                 : The name of the web service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568240 = path.getOrDefault("resourceGroupName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceGroupName", valid_568240
  var valid_568241 = path.getOrDefault("subscriptionId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "subscriptionId", valid_568241
  var valid_568242 = path.getOrDefault("webServiceName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "webServiceName", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
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

proc call*(call_568244: Call_WebServicesRemove_568237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified web service.
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_WebServicesRemove_568237; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; webServiceName: string): Recallable =
  ## webServicesRemove
  ## Deletes the specified web service.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   webServiceName: string (required)
  ##                 : The name of the web service.
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  add(path_568246, "resourceGroupName", newJString(resourceGroupName))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  add(path_568246, "webServiceName", newJString(webServiceName))
  result = call_568245.call(path_568246, query_568247, nil, nil, nil)

var webServicesRemove* = Call_WebServicesRemove_568237(name: "webServicesRemove",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/webServices/{webServiceName}",
    validator: validate_WebServicesRemove_568238, base: "",
    url: url_WebServicesRemove_568239, schemes: {Scheme.Https})
type
  Call_WebServicesCreateRegionalProperties_568261 = ref object of OpenApiRestCall_567658
proc url_WebServicesCreateRegionalProperties_568263(protocol: Scheme; host: string;
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

proc validate_WebServicesCreateRegionalProperties_568262(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an encrypted credentials parameter blob for the specified region. To get the web service from a region other than the region in which it has been created, you must first call Create Regional Web Services Properties to create a copy of the encrypted credential parameter blob in that region. You only need to do this before the first time that you get the web service in the new region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   webServiceName: JString (required)
  ##                 : The name of the web service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568264 = path.getOrDefault("resourceGroupName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "resourceGroupName", valid_568264
  var valid_568265 = path.getOrDefault("subscriptionId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "subscriptionId", valid_568265
  var valid_568266 = path.getOrDefault("webServiceName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "webServiceName", valid_568266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   region: JString (required)
  ##         : The region for which encrypted credential parameters are created.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568267 = query.getOrDefault("api-version")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "api-version", valid_568267
  var valid_568268 = query.getOrDefault("region")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "region", valid_568268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568269: Call_WebServicesCreateRegionalProperties_568261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an encrypted credentials parameter blob for the specified region. To get the web service from a region other than the region in which it has been created, you must first call Create Regional Web Services Properties to create a copy of the encrypted credential parameter blob in that region. You only need to do this before the first time that you get the web service in the new region.
  ## 
  let valid = call_568269.validator(path, query, header, formData, body)
  let scheme = call_568269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568269.url(scheme.get, call_568269.host, call_568269.base,
                         call_568269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568269, url, valid)

proc call*(call_568270: Call_WebServicesCreateRegionalProperties_568261;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          webServiceName: string; region: string): Recallable =
  ## webServicesCreateRegionalProperties
  ## Creates an encrypted credentials parameter blob for the specified region. To get the web service from a region other than the region in which it has been created, you must first call Create Regional Web Services Properties to create a copy of the encrypted credential parameter blob in that region. You only need to do this before the first time that you get the web service in the new region.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   webServiceName: string (required)
  ##                 : The name of the web service.
  ##   region: string (required)
  ##         : The region for which encrypted credential parameters are created.
  var path_568271 = newJObject()
  var query_568272 = newJObject()
  add(path_568271, "resourceGroupName", newJString(resourceGroupName))
  add(query_568272, "api-version", newJString(apiVersion))
  add(path_568271, "subscriptionId", newJString(subscriptionId))
  add(path_568271, "webServiceName", newJString(webServiceName))
  add(query_568272, "region", newJString(region))
  result = call_568270.call(path_568271, query_568272, nil, nil, nil)

var webServicesCreateRegionalProperties* = Call_WebServicesCreateRegionalProperties_568261(
    name: "webServicesCreateRegionalProperties", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/webServices/{webServiceName}/CreateRegionalBlob",
    validator: validate_WebServicesCreateRegionalProperties_568262, base: "",
    url: url_WebServicesCreateRegionalProperties_568263, schemes: {Scheme.Https})
type
  Call_WebServicesListKeys_568273 = ref object of OpenApiRestCall_567658
proc url_WebServicesListKeys_568275(protocol: Scheme; host: string; base: string;
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

proc validate_WebServicesListKeys_568274(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the access keys for the specified web service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   webServiceName: JString (required)
  ##                 : The name of the web service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568276 = path.getOrDefault("resourceGroupName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "resourceGroupName", valid_568276
  var valid_568277 = path.getOrDefault("subscriptionId")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "subscriptionId", valid_568277
  var valid_568278 = path.getOrDefault("webServiceName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "webServiceName", valid_568278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearning resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568279 = query.getOrDefault("api-version")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "api-version", valid_568279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568280: Call_WebServicesListKeys_568273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access keys for the specified web service.
  ## 
  let valid = call_568280.validator(path, query, header, formData, body)
  let scheme = call_568280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568280.url(scheme.get, call_568280.host, call_568280.base,
                         call_568280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568280, url, valid)

proc call*(call_568281: Call_WebServicesListKeys_568273; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; webServiceName: string): Recallable =
  ## webServicesListKeys
  ## Gets the access keys for the specified web service.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the web service is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearning resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   webServiceName: string (required)
  ##                 : The name of the web service.
  var path_568282 = newJObject()
  var query_568283 = newJObject()
  add(path_568282, "resourceGroupName", newJString(resourceGroupName))
  add(query_568283, "api-version", newJString(apiVersion))
  add(path_568282, "subscriptionId", newJString(subscriptionId))
  add(path_568282, "webServiceName", newJString(webServiceName))
  result = call_568281.call(path_568282, query_568283, nil, nil, nil)

var webServicesListKeys* = Call_WebServicesListKeys_568273(
    name: "webServicesListKeys", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearning/webServices/{webServiceName}/listKeys",
    validator: validate_WebServicesListKeys_568274, base: "",
    url: url_WebServicesListKeys_568275, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
