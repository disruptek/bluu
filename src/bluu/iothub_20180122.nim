
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: iotHubClient
## version: 2018-01-22
## termsOfService: (not provided)
## license: (not provided)
## 
## Use this API to manage the IoT hubs in your Azure subscription.
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

  OpenApiRestCall_593437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593437): Option[Scheme] {.used.} =
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
  macServiceName = "iothub"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593659 = ref object of OpenApiRestCall_593437
proc url_OperationsList_593661(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593660(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available IoT Hub REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593820 = query.getOrDefault("api-version")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "api-version", valid_593820
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593843: Call_OperationsList_593659; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available IoT Hub REST API operations.
  ## 
  let valid = call_593843.validator(path, query, header, formData, body)
  let scheme = call_593843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593843.url(scheme.get, call_593843.host, call_593843.base,
                         call_593843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593843, url, valid)

proc call*(call_593914: Call_OperationsList_593659; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available IoT Hub REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  var query_593915 = newJObject()
  add(query_593915, "api-version", newJString(apiVersion))
  result = call_593914.call(nil, query_593915, nil, nil, nil)

var operationsList* = Call_OperationsList_593659(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Devices/operations",
    validator: validate_OperationsList_593660, base: "", url: url_OperationsList_593661,
    schemes: {Scheme.Https})
type
  Call_IotHubResourceListBySubscription_593955 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceListBySubscription_593957(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceListBySubscription_593956(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the IoT hubs in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593972 = path.getOrDefault("subscriptionId")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "subscriptionId", valid_593972
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593973 = query.getOrDefault("api-version")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "api-version", valid_593973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593974: Call_IotHubResourceListBySubscription_593955;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the IoT hubs in a subscription.
  ## 
  let valid = call_593974.validator(path, query, header, formData, body)
  let scheme = call_593974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593974.url(scheme.get, call_593974.host, call_593974.base,
                         call_593974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593974, url, valid)

proc call*(call_593975: Call_IotHubResourceListBySubscription_593955;
          apiVersion: string; subscriptionId: string): Recallable =
  ## iotHubResourceListBySubscription
  ## Get all the IoT hubs in a subscription.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_593976 = newJObject()
  var query_593977 = newJObject()
  add(query_593977, "api-version", newJString(apiVersion))
  add(path_593976, "subscriptionId", newJString(subscriptionId))
  result = call_593975.call(path_593976, query_593977, nil, nil, nil)

var iotHubResourceListBySubscription* = Call_IotHubResourceListBySubscription_593955(
    name: "iotHubResourceListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Devices/IotHubs",
    validator: validate_IotHubResourceListBySubscription_593956, base: "",
    url: url_IotHubResourceListBySubscription_593957, schemes: {Scheme.Https})
type
  Call_IotHubResourceCheckNameAvailability_593978 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceCheckNameAvailability_593980(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Devices/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceCheckNameAvailability_593979(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check if an IoT hub name is available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593981 = path.getOrDefault("subscriptionId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "subscriptionId", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593982 = query.getOrDefault("api-version")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "api-version", valid_593982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   operationInputs: JObject (required)
  ##                  : Set the name parameter in the OperationInputs structure to the name of the IoT hub to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_IotHubResourceCheckNameAvailability_593978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check if an IoT hub name is available.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_IotHubResourceCheckNameAvailability_593978;
          apiVersion: string; subscriptionId: string; operationInputs: JsonNode): Recallable =
  ## iotHubResourceCheckNameAvailability
  ## Check if an IoT hub name is available.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   operationInputs: JObject (required)
  ##                  : Set the name parameter in the OperationInputs structure to the name of the IoT hub to check.
  var path_593986 = newJObject()
  var query_593987 = newJObject()
  var body_593988 = newJObject()
  add(query_593987, "api-version", newJString(apiVersion))
  add(path_593986, "subscriptionId", newJString(subscriptionId))
  if operationInputs != nil:
    body_593988 = operationInputs
  result = call_593985.call(path_593986, query_593987, nil, nil, body_593988)

var iotHubResourceCheckNameAvailability* = Call_IotHubResourceCheckNameAvailability_593978(
    name: "iotHubResourceCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Devices/checkNameAvailability",
    validator: validate_IotHubResourceCheckNameAvailability_593979, base: "",
    url: url_IotHubResourceCheckNameAvailability_593980, schemes: {Scheme.Https})
type
  Call_IotHubResourceListByResourceGroup_593989 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceListByResourceGroup_593991(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceListByResourceGroup_593990(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the IoT hubs in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593992 = path.getOrDefault("resourceGroupName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "resourceGroupName", valid_593992
  var valid_593993 = path.getOrDefault("subscriptionId")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "subscriptionId", valid_593993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593994 = query.getOrDefault("api-version")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "api-version", valid_593994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593995: Call_IotHubResourceListByResourceGroup_593989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the IoT hubs in a resource group.
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_IotHubResourceListByResourceGroup_593989;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## iotHubResourceListByResourceGroup
  ## Get all the IoT hubs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_593997 = newJObject()
  var query_593998 = newJObject()
  add(path_593997, "resourceGroupName", newJString(resourceGroupName))
  add(query_593998, "api-version", newJString(apiVersion))
  add(path_593997, "subscriptionId", newJString(subscriptionId))
  result = call_593996.call(path_593997, query_593998, nil, nil, nil)

var iotHubResourceListByResourceGroup* = Call_IotHubResourceListByResourceGroup_593989(
    name: "iotHubResourceListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs",
    validator: validate_IotHubResourceListByResourceGroup_593990, base: "",
    url: url_IotHubResourceListByResourceGroup_593991, schemes: {Scheme.Https})
type
  Call_IotHubResourceCreateOrUpdate_594010 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceCreateOrUpdate_594012(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceCreateOrUpdate_594011(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update the metadata of an Iot hub. The usual pattern to modify a property is to retrieve the IoT hub metadata and security metadata, and then combine them with the modified values in a new body to update the IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594013 = path.getOrDefault("resourceGroupName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "resourceGroupName", valid_594013
  var valid_594014 = path.getOrDefault("subscriptionId")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "subscriptionId", valid_594014
  var valid_594015 = path.getOrDefault("resourceName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "resourceName", valid_594015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594016 = query.getOrDefault("api-version")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "api-version", valid_594016
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the IoT Hub. Do not specify for creating a brand new IoT Hub. Required to update an existing IoT Hub.
  section = newJObject()
  var valid_594017 = header.getOrDefault("If-Match")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "If-Match", valid_594017
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   iotHubDescription: JObject (required)
  ##                    : The IoT hub metadata and security metadata.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594019: Call_IotHubResourceCreateOrUpdate_594010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the metadata of an Iot hub. The usual pattern to modify a property is to retrieve the IoT hub metadata and security metadata, and then combine them with the modified values in a new body to update the IoT hub.
  ## 
  let valid = call_594019.validator(path, query, header, formData, body)
  let scheme = call_594019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594019.url(scheme.get, call_594019.host, call_594019.base,
                         call_594019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594019, url, valid)

proc call*(call_594020: Call_IotHubResourceCreateOrUpdate_594010;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; iotHubDescription: JsonNode): Recallable =
  ## iotHubResourceCreateOrUpdate
  ## Create or update the metadata of an Iot hub. The usual pattern to modify a property is to retrieve the IoT hub metadata and security metadata, and then combine them with the modified values in a new body to update the IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  ##   iotHubDescription: JObject (required)
  ##                    : The IoT hub metadata and security metadata.
  var path_594021 = newJObject()
  var query_594022 = newJObject()
  var body_594023 = newJObject()
  add(path_594021, "resourceGroupName", newJString(resourceGroupName))
  add(query_594022, "api-version", newJString(apiVersion))
  add(path_594021, "subscriptionId", newJString(subscriptionId))
  add(path_594021, "resourceName", newJString(resourceName))
  if iotHubDescription != nil:
    body_594023 = iotHubDescription
  result = call_594020.call(path_594021, query_594022, nil, nil, body_594023)

var iotHubResourceCreateOrUpdate* = Call_IotHubResourceCreateOrUpdate_594010(
    name: "iotHubResourceCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}",
    validator: validate_IotHubResourceCreateOrUpdate_594011, base: "",
    url: url_IotHubResourceCreateOrUpdate_594012, schemes: {Scheme.Https})
type
  Call_IotHubResourceGet_593999 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceGet_594001(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceGet_594000(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the non-security related metadata of an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594002 = path.getOrDefault("resourceGroupName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "resourceGroupName", valid_594002
  var valid_594003 = path.getOrDefault("subscriptionId")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "subscriptionId", valid_594003
  var valid_594004 = path.getOrDefault("resourceName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "resourceName", valid_594004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594005 = query.getOrDefault("api-version")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "api-version", valid_594005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594006: Call_IotHubResourceGet_593999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the non-security related metadata of an IoT hub.
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_IotHubResourceGet_593999; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## iotHubResourceGet
  ## Get the non-security related metadata of an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_594008 = newJObject()
  var query_594009 = newJObject()
  add(path_594008, "resourceGroupName", newJString(resourceGroupName))
  add(query_594009, "api-version", newJString(apiVersion))
  add(path_594008, "subscriptionId", newJString(subscriptionId))
  add(path_594008, "resourceName", newJString(resourceName))
  result = call_594007.call(path_594008, query_594009, nil, nil, nil)

var iotHubResourceGet* = Call_IotHubResourceGet_593999(name: "iotHubResourceGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}",
    validator: validate_IotHubResourceGet_594000, base: "",
    url: url_IotHubResourceGet_594001, schemes: {Scheme.Https})
type
  Call_IotHubResourceUpdate_594035 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceUpdate_594037(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceUpdate_594036(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing IoT Hub tags. to update other fields use the CreateOrUpdate method
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : Name of iot hub to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594055 = path.getOrDefault("resourceGroupName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "resourceGroupName", valid_594055
  var valid_594056 = path.getOrDefault("subscriptionId")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "subscriptionId", valid_594056
  var valid_594057 = path.getOrDefault("resourceName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "resourceName", valid_594057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594058 = query.getOrDefault("api-version")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "api-version", valid_594058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   IotHubTags: JObject (required)
  ##             : Updated tag information to set into the iot hub instance.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_IotHubResourceUpdate_594035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing IoT Hub tags. to update other fields use the CreateOrUpdate method
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_IotHubResourceUpdate_594035;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; IotHubTags: JsonNode): Recallable =
  ## iotHubResourceUpdate
  ## Update an existing IoT Hub tags. to update other fields use the CreateOrUpdate method
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : Name of iot hub to update.
  ##   IotHubTags: JObject (required)
  ##             : Updated tag information to set into the iot hub instance.
  var path_594062 = newJObject()
  var query_594063 = newJObject()
  var body_594064 = newJObject()
  add(path_594062, "resourceGroupName", newJString(resourceGroupName))
  add(query_594063, "api-version", newJString(apiVersion))
  add(path_594062, "subscriptionId", newJString(subscriptionId))
  add(path_594062, "resourceName", newJString(resourceName))
  if IotHubTags != nil:
    body_594064 = IotHubTags
  result = call_594061.call(path_594062, query_594063, nil, nil, body_594064)

var iotHubResourceUpdate* = Call_IotHubResourceUpdate_594035(
    name: "iotHubResourceUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}",
    validator: validate_IotHubResourceUpdate_594036, base: "",
    url: url_IotHubResourceUpdate_594037, schemes: {Scheme.Https})
type
  Call_IotHubResourceDelete_594024 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceDelete_594026(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceDelete_594025(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594027 = path.getOrDefault("resourceGroupName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "resourceGroupName", valid_594027
  var valid_594028 = path.getOrDefault("subscriptionId")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "subscriptionId", valid_594028
  var valid_594029 = path.getOrDefault("resourceName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "resourceName", valid_594029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594030 = query.getOrDefault("api-version")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "api-version", valid_594030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594031: Call_IotHubResourceDelete_594024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an IoT hub.
  ## 
  let valid = call_594031.validator(path, query, header, formData, body)
  let scheme = call_594031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594031.url(scheme.get, call_594031.host, call_594031.base,
                         call_594031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594031, url, valid)

proc call*(call_594032: Call_IotHubResourceDelete_594024;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## iotHubResourceDelete
  ## Delete an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_594033 = newJObject()
  var query_594034 = newJObject()
  add(path_594033, "resourceGroupName", newJString(resourceGroupName))
  add(query_594034, "api-version", newJString(apiVersion))
  add(path_594033, "subscriptionId", newJString(subscriptionId))
  add(path_594033, "resourceName", newJString(resourceName))
  result = call_594032.call(path_594033, query_594034, nil, nil, nil)

var iotHubResourceDelete* = Call_IotHubResourceDelete_594024(
    name: "iotHubResourceDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}",
    validator: validate_IotHubResourceDelete_594025, base: "",
    url: url_IotHubResourceDelete_594026, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetKeysForKeyName_594065 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceGetKeysForKeyName_594067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "keyName" in path, "`keyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/IotHubKeys/"),
               (kind: VariableSegment, value: "keyName"),
               (kind: ConstantSegment, value: "/listkeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceGetKeysForKeyName_594066(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a shared access policy by name from an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-security.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   keyName: JString (required)
  ##          : The name of the shared access policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594068 = path.getOrDefault("resourceGroupName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "resourceGroupName", valid_594068
  var valid_594069 = path.getOrDefault("keyName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "keyName", valid_594069
  var valid_594070 = path.getOrDefault("subscriptionId")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "subscriptionId", valid_594070
  var valid_594071 = path.getOrDefault("resourceName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "resourceName", valid_594071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
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

proc call*(call_594073: Call_IotHubResourceGetKeysForKeyName_594065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a shared access policy by name from an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-security.
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_IotHubResourceGetKeysForKeyName_594065;
          resourceGroupName: string; apiVersion: string; keyName: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## iotHubResourceGetKeysForKeyName
  ## Get a shared access policy by name from an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-security.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   keyName: string (required)
  ##          : The name of the shared access policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  add(path_594075, "resourceGroupName", newJString(resourceGroupName))
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "keyName", newJString(keyName))
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  add(path_594075, "resourceName", newJString(resourceName))
  result = call_594074.call(path_594075, query_594076, nil, nil, nil)

var iotHubResourceGetKeysForKeyName* = Call_IotHubResourceGetKeysForKeyName_594065(
    name: "iotHubResourceGetKeysForKeyName", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/IotHubKeys/{keyName}/listkeys",
    validator: validate_IotHubResourceGetKeysForKeyName_594066, base: "",
    url: url_IotHubResourceGetKeysForKeyName_594067, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetStats_594077 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceGetStats_594079(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/IotHubStats")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceGetStats_594078(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the statistics from an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594080 = path.getOrDefault("resourceGroupName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "resourceGroupName", valid_594080
  var valid_594081 = path.getOrDefault("subscriptionId")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "subscriptionId", valid_594081
  var valid_594082 = path.getOrDefault("resourceName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "resourceName", valid_594082
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
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

proc call*(call_594084: Call_IotHubResourceGetStats_594077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the statistics from an IoT hub.
  ## 
  let valid = call_594084.validator(path, query, header, formData, body)
  let scheme = call_594084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594084.url(scheme.get, call_594084.host, call_594084.base,
                         call_594084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594084, url, valid)

proc call*(call_594085: Call_IotHubResourceGetStats_594077;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## iotHubResourceGetStats
  ## Get the statistics from an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_594086 = newJObject()
  var query_594087 = newJObject()
  add(path_594086, "resourceGroupName", newJString(resourceGroupName))
  add(query_594087, "api-version", newJString(apiVersion))
  add(path_594086, "subscriptionId", newJString(subscriptionId))
  add(path_594086, "resourceName", newJString(resourceName))
  result = call_594085.call(path_594086, query_594087, nil, nil, nil)

var iotHubResourceGetStats* = Call_IotHubResourceGetStats_594077(
    name: "iotHubResourceGetStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/IotHubStats",
    validator: validate_IotHubResourceGetStats_594078, base: "",
    url: url_IotHubResourceGetStats_594079, schemes: {Scheme.Https})
type
  Call_CertificatesListByIotHub_594088 = ref object of OpenApiRestCall_593437
proc url_CertificatesListByIotHub_594090(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/certificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesListByIotHub_594089(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of certificates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594091 = path.getOrDefault("resourceGroupName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "resourceGroupName", valid_594091
  var valid_594092 = path.getOrDefault("subscriptionId")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "subscriptionId", valid_594092
  var valid_594093 = path.getOrDefault("resourceName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "resourceName", valid_594093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
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

proc call*(call_594095: Call_CertificatesListByIotHub_594088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of certificates.
  ## 
  let valid = call_594095.validator(path, query, header, formData, body)
  let scheme = call_594095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594095.url(scheme.get, call_594095.host, call_594095.base,
                         call_594095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594095, url, valid)

proc call*(call_594096: Call_CertificatesListByIotHub_594088;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## certificatesListByIotHub
  ## Returns the list of certificates.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_594097 = newJObject()
  var query_594098 = newJObject()
  add(path_594097, "resourceGroupName", newJString(resourceGroupName))
  add(query_594098, "api-version", newJString(apiVersion))
  add(path_594097, "subscriptionId", newJString(subscriptionId))
  add(path_594097, "resourceName", newJString(resourceName))
  result = call_594096.call(path_594097, query_594098, nil, nil, nil)

var certificatesListByIotHub* = Call_CertificatesListByIotHub_594088(
    name: "certificatesListByIotHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates",
    validator: validate_CertificatesListByIotHub_594089, base: "",
    url: url_CertificatesListByIotHub_594090, schemes: {Scheme.Https})
type
  Call_CertificatesCreateOrUpdate_594111 = ref object of OpenApiRestCall_593437
proc url_CertificatesCreateOrUpdate_594113(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesCreateOrUpdate_594112(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds new or replaces existing certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  ##   certificateName: JString (required)
  ##                  : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594114 = path.getOrDefault("resourceGroupName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "resourceGroupName", valid_594114
  var valid_594115 = path.getOrDefault("subscriptionId")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "subscriptionId", valid_594115
  var valid_594116 = path.getOrDefault("resourceName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "resourceName", valid_594116
  var valid_594117 = path.getOrDefault("certificateName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "certificateName", valid_594117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594118 = query.getOrDefault("api-version")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "api-version", valid_594118
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Certificate. Do not specify for creating a brand new certificate. Required to update an existing certificate.
  section = newJObject()
  var valid_594119 = header.getOrDefault("If-Match")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "If-Match", valid_594119
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   certificateDescription: JObject (required)
  ##                         : The certificate body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594121: Call_CertificatesCreateOrUpdate_594111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds new or replaces existing certificate.
  ## 
  let valid = call_594121.validator(path, query, header, formData, body)
  let scheme = call_594121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594121.url(scheme.get, call_594121.host, call_594121.base,
                         call_594121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594121, url, valid)

proc call*(call_594122: Call_CertificatesCreateOrUpdate_594111;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; certificateName: string;
          certificateDescription: JsonNode): Recallable =
  ## certificatesCreateOrUpdate
  ## Adds new or replaces existing certificate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  ##   certificateDescription: JObject (required)
  ##                         : The certificate body.
  var path_594123 = newJObject()
  var query_594124 = newJObject()
  var body_594125 = newJObject()
  add(path_594123, "resourceGroupName", newJString(resourceGroupName))
  add(query_594124, "api-version", newJString(apiVersion))
  add(path_594123, "subscriptionId", newJString(subscriptionId))
  add(path_594123, "resourceName", newJString(resourceName))
  add(path_594123, "certificateName", newJString(certificateName))
  if certificateDescription != nil:
    body_594125 = certificateDescription
  result = call_594122.call(path_594123, query_594124, nil, nil, body_594125)

var certificatesCreateOrUpdate* = Call_CertificatesCreateOrUpdate_594111(
    name: "certificatesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates/{certificateName}",
    validator: validate_CertificatesCreateOrUpdate_594112, base: "",
    url: url_CertificatesCreateOrUpdate_594113, schemes: {Scheme.Https})
type
  Call_CertificatesGet_594099 = ref object of OpenApiRestCall_593437
proc url_CertificatesGet_594101(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesGet_594100(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns the certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  ##   certificateName: JString (required)
  ##                  : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594102 = path.getOrDefault("resourceGroupName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "resourceGroupName", valid_594102
  var valid_594103 = path.getOrDefault("subscriptionId")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "subscriptionId", valid_594103
  var valid_594104 = path.getOrDefault("resourceName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "resourceName", valid_594104
  var valid_594105 = path.getOrDefault("certificateName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "certificateName", valid_594105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594106 = query.getOrDefault("api-version")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "api-version", valid_594106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594107: Call_CertificatesGet_594099; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the certificate.
  ## 
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_CertificatesGet_594099; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          certificateName: string): Recallable =
  ## certificatesGet
  ## Returns the certificate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_594109 = newJObject()
  var query_594110 = newJObject()
  add(path_594109, "resourceGroupName", newJString(resourceGroupName))
  add(query_594110, "api-version", newJString(apiVersion))
  add(path_594109, "subscriptionId", newJString(subscriptionId))
  add(path_594109, "resourceName", newJString(resourceName))
  add(path_594109, "certificateName", newJString(certificateName))
  result = call_594108.call(path_594109, query_594110, nil, nil, nil)

var certificatesGet* = Call_CertificatesGet_594099(name: "certificatesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates/{certificateName}",
    validator: validate_CertificatesGet_594100, base: "", url: url_CertificatesGet_594101,
    schemes: {Scheme.Https})
type
  Call_CertificatesDelete_594126 = ref object of OpenApiRestCall_593437
proc url_CertificatesDelete_594128(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesDelete_594127(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes an existing X509 certificate or does nothing if it does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  ##   certificateName: JString (required)
  ##                  : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594129 = path.getOrDefault("resourceGroupName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "resourceGroupName", valid_594129
  var valid_594130 = path.getOrDefault("subscriptionId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "subscriptionId", valid_594130
  var valid_594131 = path.getOrDefault("resourceName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "resourceName", valid_594131
  var valid_594132 = path.getOrDefault("certificateName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "certificateName", valid_594132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594133 = query.getOrDefault("api-version")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "api-version", valid_594133
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594134 = header.getOrDefault("If-Match")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "If-Match", valid_594134
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594135: Call_CertificatesDelete_594126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing X509 certificate or does nothing if it does not exist.
  ## 
  let valid = call_594135.validator(path, query, header, formData, body)
  let scheme = call_594135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594135.url(scheme.get, call_594135.host, call_594135.base,
                         call_594135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594135, url, valid)

proc call*(call_594136: Call_CertificatesDelete_594126; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          certificateName: string): Recallable =
  ## certificatesDelete
  ## Deletes an existing X509 certificate or does nothing if it does not exist.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_594137 = newJObject()
  var query_594138 = newJObject()
  add(path_594137, "resourceGroupName", newJString(resourceGroupName))
  add(query_594138, "api-version", newJString(apiVersion))
  add(path_594137, "subscriptionId", newJString(subscriptionId))
  add(path_594137, "resourceName", newJString(resourceName))
  add(path_594137, "certificateName", newJString(certificateName))
  result = call_594136.call(path_594137, query_594138, nil, nil, nil)

var certificatesDelete* = Call_CertificatesDelete_594126(
    name: "certificatesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates/{certificateName}",
    validator: validate_CertificatesDelete_594127, base: "",
    url: url_CertificatesDelete_594128, schemes: {Scheme.Https})
type
  Call_CertificatesGenerateVerificationCode_594139 = ref object of OpenApiRestCall_593437
proc url_CertificatesGenerateVerificationCode_594141(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName"),
               (kind: ConstantSegment, value: "/generateVerificationCode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesGenerateVerificationCode_594140(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates verification code for proof of possession flow. The verification code will be used to generate a leaf certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  ##   certificateName: JString (required)
  ##                  : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594142 = path.getOrDefault("resourceGroupName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "resourceGroupName", valid_594142
  var valid_594143 = path.getOrDefault("subscriptionId")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "subscriptionId", valid_594143
  var valid_594144 = path.getOrDefault("resourceName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "resourceName", valid_594144
  var valid_594145 = path.getOrDefault("certificateName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "certificateName", valid_594145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594146 = query.getOrDefault("api-version")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "api-version", valid_594146
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594147 = header.getOrDefault("If-Match")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "If-Match", valid_594147
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594148: Call_CertificatesGenerateVerificationCode_594139;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates verification code for proof of possession flow. The verification code will be used to generate a leaf certificate.
  ## 
  let valid = call_594148.validator(path, query, header, formData, body)
  let scheme = call_594148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594148.url(scheme.get, call_594148.host, call_594148.base,
                         call_594148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594148, url, valid)

proc call*(call_594149: Call_CertificatesGenerateVerificationCode_594139;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; certificateName: string): Recallable =
  ## certificatesGenerateVerificationCode
  ## Generates verification code for proof of possession flow. The verification code will be used to generate a leaf certificate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_594150 = newJObject()
  var query_594151 = newJObject()
  add(path_594150, "resourceGroupName", newJString(resourceGroupName))
  add(query_594151, "api-version", newJString(apiVersion))
  add(path_594150, "subscriptionId", newJString(subscriptionId))
  add(path_594150, "resourceName", newJString(resourceName))
  add(path_594150, "certificateName", newJString(certificateName))
  result = call_594149.call(path_594150, query_594151, nil, nil, nil)

var certificatesGenerateVerificationCode* = Call_CertificatesGenerateVerificationCode_594139(
    name: "certificatesGenerateVerificationCode", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates/{certificateName}/generateVerificationCode",
    validator: validate_CertificatesGenerateVerificationCode_594140, base: "",
    url: url_CertificatesGenerateVerificationCode_594141, schemes: {Scheme.Https})
type
  Call_CertificatesVerify_594152 = ref object of OpenApiRestCall_593437
proc url_CertificatesVerify_594154(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName"),
               (kind: ConstantSegment, value: "/verify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesVerify_594153(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Verifies the certificate's private key possession by providing the leaf cert issued by the verifying pre uploaded certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  ##   certificateName: JString (required)
  ##                  : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594155 = path.getOrDefault("resourceGroupName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "resourceGroupName", valid_594155
  var valid_594156 = path.getOrDefault("subscriptionId")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "subscriptionId", valid_594156
  var valid_594157 = path.getOrDefault("resourceName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "resourceName", valid_594157
  var valid_594158 = path.getOrDefault("certificateName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "certificateName", valid_594158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
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
  ##   If-Match: JString (required)
  ##           : ETag of the Certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594160 = header.getOrDefault("If-Match")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "If-Match", valid_594160
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   certificateVerificationBody: JObject (required)
  ##                              : The name of the certificate
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594162: Call_CertificatesVerify_594152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verifies the certificate's private key possession by providing the leaf cert issued by the verifying pre uploaded certificate.
  ## 
  let valid = call_594162.validator(path, query, header, formData, body)
  let scheme = call_594162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594162.url(scheme.get, call_594162.host, call_594162.base,
                         call_594162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594162, url, valid)

proc call*(call_594163: Call_CertificatesVerify_594152; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          certificateName: string; certificateVerificationBody: JsonNode): Recallable =
  ## certificatesVerify
  ## Verifies the certificate's private key possession by providing the leaf cert issued by the verifying pre uploaded certificate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  ##   certificateVerificationBody: JObject (required)
  ##                              : The name of the certificate
  var path_594164 = newJObject()
  var query_594165 = newJObject()
  var body_594166 = newJObject()
  add(path_594164, "resourceGroupName", newJString(resourceGroupName))
  add(query_594165, "api-version", newJString(apiVersion))
  add(path_594164, "subscriptionId", newJString(subscriptionId))
  add(path_594164, "resourceName", newJString(resourceName))
  add(path_594164, "certificateName", newJString(certificateName))
  if certificateVerificationBody != nil:
    body_594166 = certificateVerificationBody
  result = call_594163.call(path_594164, query_594165, nil, nil, body_594166)

var certificatesVerify* = Call_CertificatesVerify_594152(
    name: "certificatesVerify", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates/{certificateName}/verify",
    validator: validate_CertificatesVerify_594153, base: "",
    url: url_CertificatesVerify_594154, schemes: {Scheme.Https})
type
  Call_IotHubResourceListEventHubConsumerGroups_594167 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceListEventHubConsumerGroups_594169(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "eventHubEndpointName" in path,
        "`eventHubEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/eventHubEndpoints/"),
               (kind: VariableSegment, value: "eventHubEndpointName"),
               (kind: ConstantSegment, value: "/ConsumerGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceListEventHubConsumerGroups_594168(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of the consumer groups in the Event Hub-compatible device-to-cloud endpoint in an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   eventHubEndpointName: JString (required)
  ##                       : The name of the Event Hub-compatible endpoint.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594170 = path.getOrDefault("resourceGroupName")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "resourceGroupName", valid_594170
  var valid_594171 = path.getOrDefault("eventHubEndpointName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "eventHubEndpointName", valid_594171
  var valid_594172 = path.getOrDefault("subscriptionId")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "subscriptionId", valid_594172
  var valid_594173 = path.getOrDefault("resourceName")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "resourceName", valid_594173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
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

proc call*(call_594175: Call_IotHubResourceListEventHubConsumerGroups_594167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a list of the consumer groups in the Event Hub-compatible device-to-cloud endpoint in an IoT hub.
  ## 
  let valid = call_594175.validator(path, query, header, formData, body)
  let scheme = call_594175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594175.url(scheme.get, call_594175.host, call_594175.base,
                         call_594175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594175, url, valid)

proc call*(call_594176: Call_IotHubResourceListEventHubConsumerGroups_594167;
          resourceGroupName: string; apiVersion: string;
          eventHubEndpointName: string; subscriptionId: string; resourceName: string): Recallable =
  ## iotHubResourceListEventHubConsumerGroups
  ## Get a list of the consumer groups in the Event Hub-compatible device-to-cloud endpoint in an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   eventHubEndpointName: string (required)
  ##                       : The name of the Event Hub-compatible endpoint.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_594177 = newJObject()
  var query_594178 = newJObject()
  add(path_594177, "resourceGroupName", newJString(resourceGroupName))
  add(query_594178, "api-version", newJString(apiVersion))
  add(path_594177, "eventHubEndpointName", newJString(eventHubEndpointName))
  add(path_594177, "subscriptionId", newJString(subscriptionId))
  add(path_594177, "resourceName", newJString(resourceName))
  result = call_594176.call(path_594177, query_594178, nil, nil, nil)

var iotHubResourceListEventHubConsumerGroups* = Call_IotHubResourceListEventHubConsumerGroups_594167(
    name: "iotHubResourceListEventHubConsumerGroups", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/eventHubEndpoints/{eventHubEndpointName}/ConsumerGroups",
    validator: validate_IotHubResourceListEventHubConsumerGroups_594168, base: "",
    url: url_IotHubResourceListEventHubConsumerGroups_594169,
    schemes: {Scheme.Https})
type
  Call_IotHubResourceCreateEventHubConsumerGroup_594192 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceCreateEventHubConsumerGroup_594194(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "eventHubEndpointName" in path,
        "`eventHubEndpointName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/eventHubEndpoints/"),
               (kind: VariableSegment, value: "eventHubEndpointName"),
               (kind: ConstantSegment, value: "/ConsumerGroups/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceCreateEventHubConsumerGroup_594193(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a consumer group to an Event Hub-compatible endpoint in an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   name: JString (required)
  ##       : The name of the consumer group to add.
  ##   eventHubEndpointName: JString (required)
  ##                       : The name of the Event Hub-compatible endpoint in the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594195 = path.getOrDefault("resourceGroupName")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "resourceGroupName", valid_594195
  var valid_594196 = path.getOrDefault("name")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "name", valid_594196
  var valid_594197 = path.getOrDefault("eventHubEndpointName")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "eventHubEndpointName", valid_594197
  var valid_594198 = path.getOrDefault("subscriptionId")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "subscriptionId", valid_594198
  var valid_594199 = path.getOrDefault("resourceName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "resourceName", valid_594199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
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

proc call*(call_594201: Call_IotHubResourceCreateEventHubConsumerGroup_594192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a consumer group to an Event Hub-compatible endpoint in an IoT hub.
  ## 
  let valid = call_594201.validator(path, query, header, formData, body)
  let scheme = call_594201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594201.url(scheme.get, call_594201.host, call_594201.base,
                         call_594201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594201, url, valid)

proc call*(call_594202: Call_IotHubResourceCreateEventHubConsumerGroup_594192;
          resourceGroupName: string; apiVersion: string; name: string;
          eventHubEndpointName: string; subscriptionId: string; resourceName: string): Recallable =
  ## iotHubResourceCreateEventHubConsumerGroup
  ## Add a consumer group to an Event Hub-compatible endpoint in an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   name: string (required)
  ##       : The name of the consumer group to add.
  ##   eventHubEndpointName: string (required)
  ##                       : The name of the Event Hub-compatible endpoint in the IoT hub.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_594203 = newJObject()
  var query_594204 = newJObject()
  add(path_594203, "resourceGroupName", newJString(resourceGroupName))
  add(query_594204, "api-version", newJString(apiVersion))
  add(path_594203, "name", newJString(name))
  add(path_594203, "eventHubEndpointName", newJString(eventHubEndpointName))
  add(path_594203, "subscriptionId", newJString(subscriptionId))
  add(path_594203, "resourceName", newJString(resourceName))
  result = call_594202.call(path_594203, query_594204, nil, nil, nil)

var iotHubResourceCreateEventHubConsumerGroup* = Call_IotHubResourceCreateEventHubConsumerGroup_594192(
    name: "iotHubResourceCreateEventHubConsumerGroup", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/eventHubEndpoints/{eventHubEndpointName}/ConsumerGroups/{name}",
    validator: validate_IotHubResourceCreateEventHubConsumerGroup_594193,
    base: "", url: url_IotHubResourceCreateEventHubConsumerGroup_594194,
    schemes: {Scheme.Https})
type
  Call_IotHubResourceGetEventHubConsumerGroup_594179 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceGetEventHubConsumerGroup_594181(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "eventHubEndpointName" in path,
        "`eventHubEndpointName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/eventHubEndpoints/"),
               (kind: VariableSegment, value: "eventHubEndpointName"),
               (kind: ConstantSegment, value: "/ConsumerGroups/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceGetEventHubConsumerGroup_594180(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a consumer group from the Event Hub-compatible device-to-cloud endpoint for an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   name: JString (required)
  ##       : The name of the consumer group to retrieve.
  ##   eventHubEndpointName: JString (required)
  ##                       : The name of the Event Hub-compatible endpoint in the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594182 = path.getOrDefault("resourceGroupName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "resourceGroupName", valid_594182
  var valid_594183 = path.getOrDefault("name")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "name", valid_594183
  var valid_594184 = path.getOrDefault("eventHubEndpointName")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "eventHubEndpointName", valid_594184
  var valid_594185 = path.getOrDefault("subscriptionId")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "subscriptionId", valid_594185
  var valid_594186 = path.getOrDefault("resourceName")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "resourceName", valid_594186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594187 = query.getOrDefault("api-version")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "api-version", valid_594187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594188: Call_IotHubResourceGetEventHubConsumerGroup_594179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a consumer group from the Event Hub-compatible device-to-cloud endpoint for an IoT hub.
  ## 
  let valid = call_594188.validator(path, query, header, formData, body)
  let scheme = call_594188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594188.url(scheme.get, call_594188.host, call_594188.base,
                         call_594188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594188, url, valid)

proc call*(call_594189: Call_IotHubResourceGetEventHubConsumerGroup_594179;
          resourceGroupName: string; apiVersion: string; name: string;
          eventHubEndpointName: string; subscriptionId: string; resourceName: string): Recallable =
  ## iotHubResourceGetEventHubConsumerGroup
  ## Get a consumer group from the Event Hub-compatible device-to-cloud endpoint for an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   name: string (required)
  ##       : The name of the consumer group to retrieve.
  ##   eventHubEndpointName: string (required)
  ##                       : The name of the Event Hub-compatible endpoint in the IoT hub.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_594190 = newJObject()
  var query_594191 = newJObject()
  add(path_594190, "resourceGroupName", newJString(resourceGroupName))
  add(query_594191, "api-version", newJString(apiVersion))
  add(path_594190, "name", newJString(name))
  add(path_594190, "eventHubEndpointName", newJString(eventHubEndpointName))
  add(path_594190, "subscriptionId", newJString(subscriptionId))
  add(path_594190, "resourceName", newJString(resourceName))
  result = call_594189.call(path_594190, query_594191, nil, nil, nil)

var iotHubResourceGetEventHubConsumerGroup* = Call_IotHubResourceGetEventHubConsumerGroup_594179(
    name: "iotHubResourceGetEventHubConsumerGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/eventHubEndpoints/{eventHubEndpointName}/ConsumerGroups/{name}",
    validator: validate_IotHubResourceGetEventHubConsumerGroup_594180, base: "",
    url: url_IotHubResourceGetEventHubConsumerGroup_594181,
    schemes: {Scheme.Https})
type
  Call_IotHubResourceDeleteEventHubConsumerGroup_594205 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceDeleteEventHubConsumerGroup_594207(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "eventHubEndpointName" in path,
        "`eventHubEndpointName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/eventHubEndpoints/"),
               (kind: VariableSegment, value: "eventHubEndpointName"),
               (kind: ConstantSegment, value: "/ConsumerGroups/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceDeleteEventHubConsumerGroup_594206(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a consumer group from an Event Hub-compatible endpoint in an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   name: JString (required)
  ##       : The name of the consumer group to delete.
  ##   eventHubEndpointName: JString (required)
  ##                       : The name of the Event Hub-compatible endpoint in the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594208 = path.getOrDefault("resourceGroupName")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "resourceGroupName", valid_594208
  var valid_594209 = path.getOrDefault("name")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "name", valid_594209
  var valid_594210 = path.getOrDefault("eventHubEndpointName")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "eventHubEndpointName", valid_594210
  var valid_594211 = path.getOrDefault("subscriptionId")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "subscriptionId", valid_594211
  var valid_594212 = path.getOrDefault("resourceName")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "resourceName", valid_594212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594213 = query.getOrDefault("api-version")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "api-version", valid_594213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594214: Call_IotHubResourceDeleteEventHubConsumerGroup_594205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a consumer group from an Event Hub-compatible endpoint in an IoT hub.
  ## 
  let valid = call_594214.validator(path, query, header, formData, body)
  let scheme = call_594214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594214.url(scheme.get, call_594214.host, call_594214.base,
                         call_594214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594214, url, valid)

proc call*(call_594215: Call_IotHubResourceDeleteEventHubConsumerGroup_594205;
          resourceGroupName: string; apiVersion: string; name: string;
          eventHubEndpointName: string; subscriptionId: string; resourceName: string): Recallable =
  ## iotHubResourceDeleteEventHubConsumerGroup
  ## Delete a consumer group from an Event Hub-compatible endpoint in an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   name: string (required)
  ##       : The name of the consumer group to delete.
  ##   eventHubEndpointName: string (required)
  ##                       : The name of the Event Hub-compatible endpoint in the IoT hub.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_594216 = newJObject()
  var query_594217 = newJObject()
  add(path_594216, "resourceGroupName", newJString(resourceGroupName))
  add(query_594217, "api-version", newJString(apiVersion))
  add(path_594216, "name", newJString(name))
  add(path_594216, "eventHubEndpointName", newJString(eventHubEndpointName))
  add(path_594216, "subscriptionId", newJString(subscriptionId))
  add(path_594216, "resourceName", newJString(resourceName))
  result = call_594215.call(path_594216, query_594217, nil, nil, nil)

var iotHubResourceDeleteEventHubConsumerGroup* = Call_IotHubResourceDeleteEventHubConsumerGroup_594205(
    name: "iotHubResourceDeleteEventHubConsumerGroup",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/eventHubEndpoints/{eventHubEndpointName}/ConsumerGroups/{name}",
    validator: validate_IotHubResourceDeleteEventHubConsumerGroup_594206,
    base: "", url: url_IotHubResourceDeleteEventHubConsumerGroup_594207,
    schemes: {Scheme.Https})
type
  Call_IotHubResourceExportDevices_594218 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceExportDevices_594220(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/exportDevices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceExportDevices_594219(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports all the device identities in the IoT hub identity registry to an Azure Storage blob container. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry#import-and-export-device-identities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594221 = path.getOrDefault("resourceGroupName")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "resourceGroupName", valid_594221
  var valid_594222 = path.getOrDefault("subscriptionId")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "subscriptionId", valid_594222
  var valid_594223 = path.getOrDefault("resourceName")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "resourceName", valid_594223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
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
  ## parameters in `body` object:
  ##   exportDevicesParameters: JObject (required)
  ##                          : The parameters that specify the export devices operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594226: Call_IotHubResourceExportDevices_594218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports all the device identities in the IoT hub identity registry to an Azure Storage blob container. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry#import-and-export-device-identities.
  ## 
  let valid = call_594226.validator(path, query, header, formData, body)
  let scheme = call_594226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594226.url(scheme.get, call_594226.host, call_594226.base,
                         call_594226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594226, url, valid)

proc call*(call_594227: Call_IotHubResourceExportDevices_594218;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; exportDevicesParameters: JsonNode): Recallable =
  ## iotHubResourceExportDevices
  ## Exports all the device identities in the IoT hub identity registry to an Azure Storage blob container. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry#import-and-export-device-identities.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  ##   exportDevicesParameters: JObject (required)
  ##                          : The parameters that specify the export devices operation.
  var path_594228 = newJObject()
  var query_594229 = newJObject()
  var body_594230 = newJObject()
  add(path_594228, "resourceGroupName", newJString(resourceGroupName))
  add(query_594229, "api-version", newJString(apiVersion))
  add(path_594228, "subscriptionId", newJString(subscriptionId))
  add(path_594228, "resourceName", newJString(resourceName))
  if exportDevicesParameters != nil:
    body_594230 = exportDevicesParameters
  result = call_594227.call(path_594228, query_594229, nil, nil, body_594230)

var iotHubResourceExportDevices* = Call_IotHubResourceExportDevices_594218(
    name: "iotHubResourceExportDevices", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/exportDevices",
    validator: validate_IotHubResourceExportDevices_594219, base: "",
    url: url_IotHubResourceExportDevices_594220, schemes: {Scheme.Https})
type
  Call_IotHubResourceImportDevices_594231 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceImportDevices_594233(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/importDevices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceImportDevices_594232(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Import, update, or delete device identities in the IoT hub identity registry from a blob. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry#import-and-export-device-identities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594234 = path.getOrDefault("resourceGroupName")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "resourceGroupName", valid_594234
  var valid_594235 = path.getOrDefault("subscriptionId")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "subscriptionId", valid_594235
  var valid_594236 = path.getOrDefault("resourceName")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "resourceName", valid_594236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594237 = query.getOrDefault("api-version")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "api-version", valid_594237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   importDevicesParameters: JObject (required)
  ##                          : The parameters that specify the import devices operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594239: Call_IotHubResourceImportDevices_594231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Import, update, or delete device identities in the IoT hub identity registry from a blob. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry#import-and-export-device-identities.
  ## 
  let valid = call_594239.validator(path, query, header, formData, body)
  let scheme = call_594239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594239.url(scheme.get, call_594239.host, call_594239.base,
                         call_594239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594239, url, valid)

proc call*(call_594240: Call_IotHubResourceImportDevices_594231;
          resourceGroupName: string; apiVersion: string;
          importDevicesParameters: JsonNode; subscriptionId: string;
          resourceName: string): Recallable =
  ## iotHubResourceImportDevices
  ## Import, update, or delete device identities in the IoT hub identity registry from a blob. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry#import-and-export-device-identities.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   importDevicesParameters: JObject (required)
  ##                          : The parameters that specify the import devices operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_594241 = newJObject()
  var query_594242 = newJObject()
  var body_594243 = newJObject()
  add(path_594241, "resourceGroupName", newJString(resourceGroupName))
  add(query_594242, "api-version", newJString(apiVersion))
  if importDevicesParameters != nil:
    body_594243 = importDevicesParameters
  add(path_594241, "subscriptionId", newJString(subscriptionId))
  add(path_594241, "resourceName", newJString(resourceName))
  result = call_594240.call(path_594241, query_594242, nil, nil, body_594243)

var iotHubResourceImportDevices* = Call_IotHubResourceImportDevices_594231(
    name: "iotHubResourceImportDevices", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/importDevices",
    validator: validate_IotHubResourceImportDevices_594232, base: "",
    url: url_IotHubResourceImportDevices_594233, schemes: {Scheme.Https})
type
  Call_IotHubResourceListJobs_594244 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceListJobs_594246(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceListJobs_594245(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of all the jobs in an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594247 = path.getOrDefault("resourceGroupName")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "resourceGroupName", valid_594247
  var valid_594248 = path.getOrDefault("subscriptionId")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "subscriptionId", valid_594248
  var valid_594249 = path.getOrDefault("resourceName")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "resourceName", valid_594249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594250 = query.getOrDefault("api-version")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "api-version", valid_594250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594251: Call_IotHubResourceListJobs_594244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of all the jobs in an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry.
  ## 
  let valid = call_594251.validator(path, query, header, formData, body)
  let scheme = call_594251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594251.url(scheme.get, call_594251.host, call_594251.base,
                         call_594251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594251, url, valid)

proc call*(call_594252: Call_IotHubResourceListJobs_594244;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## iotHubResourceListJobs
  ## Get a list of all the jobs in an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_594253 = newJObject()
  var query_594254 = newJObject()
  add(path_594253, "resourceGroupName", newJString(resourceGroupName))
  add(query_594254, "api-version", newJString(apiVersion))
  add(path_594253, "subscriptionId", newJString(subscriptionId))
  add(path_594253, "resourceName", newJString(resourceName))
  result = call_594252.call(path_594253, query_594254, nil, nil, nil)

var iotHubResourceListJobs* = Call_IotHubResourceListJobs_594244(
    name: "iotHubResourceListJobs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/jobs",
    validator: validate_IotHubResourceListJobs_594245, base: "",
    url: url_IotHubResourceListJobs_594246, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetJob_594255 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceGetJob_594257(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceGetJob_594256(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the details of a job from an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   jobId: JString (required)
  ##        : The job identifier.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594258 = path.getOrDefault("resourceGroupName")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "resourceGroupName", valid_594258
  var valid_594259 = path.getOrDefault("jobId")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "jobId", valid_594259
  var valid_594260 = path.getOrDefault("subscriptionId")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "subscriptionId", valid_594260
  var valid_594261 = path.getOrDefault("resourceName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "resourceName", valid_594261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
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
  if body != nil:
    result.add "body", body

proc call*(call_594263: Call_IotHubResourceGetJob_594255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of a job from an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry.
  ## 
  let valid = call_594263.validator(path, query, header, formData, body)
  let scheme = call_594263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594263.url(scheme.get, call_594263.host, call_594263.base,
                         call_594263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594263, url, valid)

proc call*(call_594264: Call_IotHubResourceGetJob_594255;
          resourceGroupName: string; apiVersion: string; jobId: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## iotHubResourceGetJob
  ## Get the details of a job from an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   jobId: string (required)
  ##        : The job identifier.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_594265 = newJObject()
  var query_594266 = newJObject()
  add(path_594265, "resourceGroupName", newJString(resourceGroupName))
  add(query_594266, "api-version", newJString(apiVersion))
  add(path_594265, "jobId", newJString(jobId))
  add(path_594265, "subscriptionId", newJString(subscriptionId))
  add(path_594265, "resourceName", newJString(resourceName))
  result = call_594264.call(path_594265, query_594266, nil, nil, nil)

var iotHubResourceGetJob* = Call_IotHubResourceGetJob_594255(
    name: "iotHubResourceGetJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/jobs/{jobId}",
    validator: validate_IotHubResourceGetJob_594256, base: "",
    url: url_IotHubResourceGetJob_594257, schemes: {Scheme.Https})
type
  Call_IotHubResourceListKeys_594267 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceListKeys_594269(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/listkeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceListKeys_594268(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the security metadata for an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-security.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594270 = path.getOrDefault("resourceGroupName")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "resourceGroupName", valid_594270
  var valid_594271 = path.getOrDefault("subscriptionId")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "subscriptionId", valid_594271
  var valid_594272 = path.getOrDefault("resourceName")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "resourceName", valid_594272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594273 = query.getOrDefault("api-version")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "api-version", valid_594273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594274: Call_IotHubResourceListKeys_594267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the security metadata for an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-security.
  ## 
  let valid = call_594274.validator(path, query, header, formData, body)
  let scheme = call_594274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594274.url(scheme.get, call_594274.host, call_594274.base,
                         call_594274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594274, url, valid)

proc call*(call_594275: Call_IotHubResourceListKeys_594267;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## iotHubResourceListKeys
  ## Get the security metadata for an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-security.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_594276 = newJObject()
  var query_594277 = newJObject()
  add(path_594276, "resourceGroupName", newJString(resourceGroupName))
  add(query_594277, "api-version", newJString(apiVersion))
  add(path_594276, "subscriptionId", newJString(subscriptionId))
  add(path_594276, "resourceName", newJString(resourceName))
  result = call_594275.call(path_594276, query_594277, nil, nil, nil)

var iotHubResourceListKeys* = Call_IotHubResourceListKeys_594267(
    name: "iotHubResourceListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/listkeys",
    validator: validate_IotHubResourceListKeys_594268, base: "",
    url: url_IotHubResourceListKeys_594269, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetQuotaMetrics_594278 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceGetQuotaMetrics_594280(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/quotaMetrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceGetQuotaMetrics_594279(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the quota metrics for an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594281 = path.getOrDefault("resourceGroupName")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "resourceGroupName", valid_594281
  var valid_594282 = path.getOrDefault("subscriptionId")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "subscriptionId", valid_594282
  var valid_594283 = path.getOrDefault("resourceName")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "resourceName", valid_594283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594284 = query.getOrDefault("api-version")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "api-version", valid_594284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594285: Call_IotHubResourceGetQuotaMetrics_594278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the quota metrics for an IoT hub.
  ## 
  let valid = call_594285.validator(path, query, header, formData, body)
  let scheme = call_594285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594285.url(scheme.get, call_594285.host, call_594285.base,
                         call_594285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594285, url, valid)

proc call*(call_594286: Call_IotHubResourceGetQuotaMetrics_594278;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## iotHubResourceGetQuotaMetrics
  ## Get the quota metrics for an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_594287 = newJObject()
  var query_594288 = newJObject()
  add(path_594287, "resourceGroupName", newJString(resourceGroupName))
  add(query_594288, "api-version", newJString(apiVersion))
  add(path_594287, "subscriptionId", newJString(subscriptionId))
  add(path_594287, "resourceName", newJString(resourceName))
  result = call_594286.call(path_594287, query_594288, nil, nil, nil)

var iotHubResourceGetQuotaMetrics* = Call_IotHubResourceGetQuotaMetrics_594278(
    name: "iotHubResourceGetQuotaMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/quotaMetrics",
    validator: validate_IotHubResourceGetQuotaMetrics_594279, base: "",
    url: url_IotHubResourceGetQuotaMetrics_594280, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetValidSkus_594289 = ref object of OpenApiRestCall_593437
proc url_IotHubResourceGetValidSkus_594291(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceGetValidSkus_594290(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of valid SKUs for an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594292 = path.getOrDefault("resourceGroupName")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "resourceGroupName", valid_594292
  var valid_594293 = path.getOrDefault("subscriptionId")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "subscriptionId", valid_594293
  var valid_594294 = path.getOrDefault("resourceName")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "resourceName", valid_594294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594295 = query.getOrDefault("api-version")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "api-version", valid_594295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594296: Call_IotHubResourceGetValidSkus_594289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of valid SKUs for an IoT hub.
  ## 
  let valid = call_594296.validator(path, query, header, formData, body)
  let scheme = call_594296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594296.url(scheme.get, call_594296.host, call_594296.base,
                         call_594296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594296, url, valid)

proc call*(call_594297: Call_IotHubResourceGetValidSkus_594289;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## iotHubResourceGetValidSkus
  ## Get the list of valid SKUs for an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_594298 = newJObject()
  var query_594299 = newJObject()
  add(path_594298, "resourceGroupName", newJString(resourceGroupName))
  add(query_594299, "api-version", newJString(apiVersion))
  add(path_594298, "subscriptionId", newJString(subscriptionId))
  add(path_594298, "resourceName", newJString(resourceName))
  result = call_594297.call(path_594298, query_594299, nil, nil, nil)

var iotHubResourceGetValidSkus* = Call_IotHubResourceGetValidSkus_594289(
    name: "iotHubResourceGetValidSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/skus",
    validator: validate_IotHubResourceGetValidSkus_594290, base: "",
    url: url_IotHubResourceGetValidSkus_594291, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
