
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AzureBridgeAdminClient
## version: 2016-01-01
## termsOfService: (not provided)
## license: (not provided)
## 
## AzureBridge Admin Client.
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

  OpenApiRestCall_582441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_582441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_582441): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-Activation"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ActivationsList_582663 = ref object of OpenApiRestCall_582441
proc url_ActivationsList_582665(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureBridge.Admin/activations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActivationsList_582664(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns the list of activations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : The resource group the resource is located under.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_582825 = path.getOrDefault("subscriptionId")
  valid_582825 = validateParameter(valid_582825, JString, required = true,
                                 default = nil)
  if valid_582825 != nil:
    section.add "subscriptionId", valid_582825
  var valid_582826 = path.getOrDefault("resourceGroup")
  valid_582826 = validateParameter(valid_582826, JString, required = true,
                                 default = nil)
  if valid_582826 != nil:
    section.add "resourceGroup", valid_582826
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582840 = query.getOrDefault("api-version")
  valid_582840 = validateParameter(valid_582840, JString, required = true,
                                 default = newJString("2016-01-01"))
  if valid_582840 != nil:
    section.add "api-version", valid_582840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582867: Call_ActivationsList_582663; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of activations.
  ## 
  let valid = call_582867.validator(path, query, header, formData, body)
  let scheme = call_582867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582867.url(scheme.get, call_582867.host, call_582867.base,
                         call_582867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582867, url, valid)

proc call*(call_582938: Call_ActivationsList_582663; subscriptionId: string;
          resourceGroup: string; apiVersion: string = "2016-01-01"): Recallable =
  ## activationsList
  ## Returns the list of activations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : The resource group the resource is located under.
  var path_582939 = newJObject()
  var query_582941 = newJObject()
  add(query_582941, "api-version", newJString(apiVersion))
  add(path_582939, "subscriptionId", newJString(subscriptionId))
  add(path_582939, "resourceGroup", newJString(resourceGroup))
  result = call_582938.call(path_582939, query_582941, nil, nil, nil)

var activationsList* = Call_ActivationsList_582663(name: "activationsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroup}/providers/Microsoft.AzureBridge.Admin/activations",
    validator: validate_ActivationsList_582664, base: "", url: url_ActivationsList_582665,
    schemes: {Scheme.Https})
type
  Call_ActivationsCreateOrUpdate_582991 = ref object of OpenApiRestCall_582441
proc url_ActivationsCreateOrUpdate_582993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "activationName" in path, "`activationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureBridge.Admin/activations/"),
               (kind: VariableSegment, value: "activationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActivationsCreateOrUpdate_582992(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new activation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   activationName: JString (required)
  ##                 : Name of the activation.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : The resource group the resource is located under.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `activationName` field"
  var valid_583003 = path.getOrDefault("activationName")
  valid_583003 = validateParameter(valid_583003, JString, required = true,
                                 default = nil)
  if valid_583003 != nil:
    section.add "activationName", valid_583003
  var valid_583004 = path.getOrDefault("subscriptionId")
  valid_583004 = validateParameter(valid_583004, JString, required = true,
                                 default = nil)
  if valid_583004 != nil:
    section.add "subscriptionId", valid_583004
  var valid_583005 = path.getOrDefault("resourceGroup")
  valid_583005 = validateParameter(valid_583005, JString, required = true,
                                 default = nil)
  if valid_583005 != nil:
    section.add "resourceGroup", valid_583005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583006 = query.getOrDefault("api-version")
  valid_583006 = validateParameter(valid_583006, JString, required = true,
                                 default = newJString("2016-01-01"))
  if valid_583006 != nil:
    section.add "api-version", valid_583006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   activation: JObject (required)
  ##             : new activation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_583008: Call_ActivationsCreateOrUpdate_582991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new activation.
  ## 
  let valid = call_583008.validator(path, query, header, formData, body)
  let scheme = call_583008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583008.url(scheme.get, call_583008.host, call_583008.base,
                         call_583008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583008, url, valid)

proc call*(call_583009: Call_ActivationsCreateOrUpdate_582991;
          activationName: string; subscriptionId: string; resourceGroup: string;
          activation: JsonNode; apiVersion: string = "2016-01-01"): Recallable =
  ## activationsCreateOrUpdate
  ## Create a new activation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   activationName: string (required)
  ##                 : Name of the activation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : The resource group the resource is located under.
  ##   activation: JObject (required)
  ##             : new activation.
  var path_583010 = newJObject()
  var query_583011 = newJObject()
  var body_583012 = newJObject()
  add(query_583011, "api-version", newJString(apiVersion))
  add(path_583010, "activationName", newJString(activationName))
  add(path_583010, "subscriptionId", newJString(subscriptionId))
  add(path_583010, "resourceGroup", newJString(resourceGroup))
  if activation != nil:
    body_583012 = activation
  result = call_583009.call(path_583010, query_583011, nil, nil, body_583012)

var activationsCreateOrUpdate* = Call_ActivationsCreateOrUpdate_582991(
    name: "activationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroup}/providers/Microsoft.AzureBridge.Admin/activations/{activationName}",
    validator: validate_ActivationsCreateOrUpdate_582992, base: "",
    url: url_ActivationsCreateOrUpdate_582993, schemes: {Scheme.Https})
type
  Call_ActivationsGet_582980 = ref object of OpenApiRestCall_582441
proc url_ActivationsGet_582982(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "activationName" in path, "`activationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureBridge.Admin/activations/"),
               (kind: VariableSegment, value: "activationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActivationsGet_582981(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns activation name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   activationName: JString (required)
  ##                 : Name of the activation.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : The resource group the resource is located under.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `activationName` field"
  var valid_582983 = path.getOrDefault("activationName")
  valid_582983 = validateParameter(valid_582983, JString, required = true,
                                 default = nil)
  if valid_582983 != nil:
    section.add "activationName", valid_582983
  var valid_582984 = path.getOrDefault("subscriptionId")
  valid_582984 = validateParameter(valid_582984, JString, required = true,
                                 default = nil)
  if valid_582984 != nil:
    section.add "subscriptionId", valid_582984
  var valid_582985 = path.getOrDefault("resourceGroup")
  valid_582985 = validateParameter(valid_582985, JString, required = true,
                                 default = nil)
  if valid_582985 != nil:
    section.add "resourceGroup", valid_582985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582986 = query.getOrDefault("api-version")
  valid_582986 = validateParameter(valid_582986, JString, required = true,
                                 default = newJString("2016-01-01"))
  if valid_582986 != nil:
    section.add "api-version", valid_582986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582987: Call_ActivationsGet_582980; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns activation name.
  ## 
  let valid = call_582987.validator(path, query, header, formData, body)
  let scheme = call_582987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582987.url(scheme.get, call_582987.host, call_582987.base,
                         call_582987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582987, url, valid)

proc call*(call_582988: Call_ActivationsGet_582980; activationName: string;
          subscriptionId: string; resourceGroup: string;
          apiVersion: string = "2016-01-01"): Recallable =
  ## activationsGet
  ## Returns activation name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   activationName: string (required)
  ##                 : Name of the activation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : The resource group the resource is located under.
  var path_582989 = newJObject()
  var query_582990 = newJObject()
  add(query_582990, "api-version", newJString(apiVersion))
  add(path_582989, "activationName", newJString(activationName))
  add(path_582989, "subscriptionId", newJString(subscriptionId))
  add(path_582989, "resourceGroup", newJString(resourceGroup))
  result = call_582988.call(path_582989, query_582990, nil, nil, nil)

var activationsGet* = Call_ActivationsGet_582980(name: "activationsGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroup}/providers/Microsoft.AzureBridge.Admin/activations/{activationName}",
    validator: validate_ActivationsGet_582981, base: "", url: url_ActivationsGet_582982,
    schemes: {Scheme.Https})
type
  Call_ActivationsDelete_583013 = ref object of OpenApiRestCall_582441
proc url_ActivationsDelete_583015(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "activationName" in path, "`activationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureBridge.Admin/activations/"),
               (kind: VariableSegment, value: "activationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActivationsDelete_583014(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete an activation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   activationName: JString (required)
  ##                 : Name of the activation.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : The resource group the resource is located under.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `activationName` field"
  var valid_583016 = path.getOrDefault("activationName")
  valid_583016 = validateParameter(valid_583016, JString, required = true,
                                 default = nil)
  if valid_583016 != nil:
    section.add "activationName", valid_583016
  var valid_583017 = path.getOrDefault("subscriptionId")
  valid_583017 = validateParameter(valid_583017, JString, required = true,
                                 default = nil)
  if valid_583017 != nil:
    section.add "subscriptionId", valid_583017
  var valid_583018 = path.getOrDefault("resourceGroup")
  valid_583018 = validateParameter(valid_583018, JString, required = true,
                                 default = nil)
  if valid_583018 != nil:
    section.add "resourceGroup", valid_583018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583019 = query.getOrDefault("api-version")
  valid_583019 = validateParameter(valid_583019, JString, required = true,
                                 default = newJString("2016-01-01"))
  if valid_583019 != nil:
    section.add "api-version", valid_583019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_583020: Call_ActivationsDelete_583013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an activation.
  ## 
  let valid = call_583020.validator(path, query, header, formData, body)
  let scheme = call_583020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583020.url(scheme.get, call_583020.host, call_583020.base,
                         call_583020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583020, url, valid)

proc call*(call_583021: Call_ActivationsDelete_583013; activationName: string;
          subscriptionId: string; resourceGroup: string;
          apiVersion: string = "2016-01-01"): Recallable =
  ## activationsDelete
  ## Delete an activation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   activationName: string (required)
  ##                 : Name of the activation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : The resource group the resource is located under.
  var path_583022 = newJObject()
  var query_583023 = newJObject()
  add(query_583023, "api-version", newJString(apiVersion))
  add(path_583022, "activationName", newJString(activationName))
  add(path_583022, "subscriptionId", newJString(subscriptionId))
  add(path_583022, "resourceGroup", newJString(resourceGroup))
  result = call_583021.call(path_583022, query_583023, nil, nil, nil)

var activationsDelete* = Call_ActivationsDelete_583013(name: "activationsDelete",
    meth: HttpMethod.HttpDelete,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroup}/providers/Microsoft.AzureBridge.Admin/activations/{activationName}",
    validator: validate_ActivationsDelete_583014, base: "",
    url: url_ActivationsDelete_583015, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
