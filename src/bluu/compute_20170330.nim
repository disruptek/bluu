
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ComputeManagementClient
## version: 2017-03-30
## termsOfService: (not provided)
## license: (not provided)
## 
## The Compute Management Client.
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
  macServiceName = "compute"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AvailabilitySetsListBySubscription_567889 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsListBySubscription_567891(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Compute/availabilitySets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilitySetsListBySubscription_567890(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all availability sets in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568065 = path.getOrDefault("subscriptionId")
  valid_568065 = validateParameter(valid_568065, JString, required = true,
                                 default = nil)
  if valid_568065 != nil:
    section.add "subscriptionId", valid_568065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply to the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568066 = query.getOrDefault("api-version")
  valid_568066 = validateParameter(valid_568066, JString, required = true,
                                 default = nil)
  if valid_568066 != nil:
    section.add "api-version", valid_568066
  var valid_568067 = query.getOrDefault("$expand")
  valid_568067 = validateParameter(valid_568067, JString, required = false,
                                 default = nil)
  if valid_568067 != nil:
    section.add "$expand", valid_568067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568090: Call_AvailabilitySetsListBySubscription_567889;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all availability sets in a subscription.
  ## 
  let valid = call_568090.validator(path, query, header, formData, body)
  let scheme = call_568090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568090.url(scheme.get, call_568090.host, call_568090.base,
                         call_568090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568090, url, valid)

proc call*(call_568161: Call_AvailabilitySetsListBySubscription_567889;
          apiVersion: string; subscriptionId: string; Expand: string = ""): Recallable =
  ## availabilitySetsListBySubscription
  ## Lists all availability sets in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : The expand expression to apply to the operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568162 = newJObject()
  var query_568164 = newJObject()
  add(query_568164, "api-version", newJString(apiVersion))
  add(query_568164, "$expand", newJString(Expand))
  add(path_568162, "subscriptionId", newJString(subscriptionId))
  result = call_568161.call(path_568162, query_568164, nil, nil, nil)

var availabilitySetsListBySubscription* = Call_AvailabilitySetsListBySubscription_567889(
    name: "availabilitySetsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/availabilitySets",
    validator: validate_AvailabilitySetsListBySubscription_567890, base: "",
    url: url_AvailabilitySetsListBySubscription_567891, schemes: {Scheme.Https})
type
  Call_ImagesList_568203 = ref object of OpenApiRestCall_567667
proc url_ImagesList_568205(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/images")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImagesList_568204(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568207 = query.getOrDefault("api-version")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "api-version", valid_568207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_ImagesList_568203; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_ImagesList_568203; apiVersion: string;
          subscriptionId: string): Recallable =
  ## imagesList
  ## Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568210 = newJObject()
  var query_568211 = newJObject()
  add(query_568211, "api-version", newJString(apiVersion))
  add(path_568210, "subscriptionId", newJString(subscriptionId))
  result = call_568209.call(path_568210, query_568211, nil, nil, nil)

var imagesList* = Call_ImagesList_568203(name: "imagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/images",
                                      validator: validate_ImagesList_568204,
                                      base: "", url: url_ImagesList_568205,
                                      schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListPublishers_568212 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineImagesListPublishers_568214(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImagesListPublishers_568213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual machine image publishers for the specified Azure location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568215 = path.getOrDefault("subscriptionId")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "subscriptionId", valid_568215
  var valid_568216 = path.getOrDefault("location")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "location", valid_568216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568217 = query.getOrDefault("api-version")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "api-version", valid_568217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568218: Call_VirtualMachineImagesListPublishers_568212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine image publishers for the specified Azure location.
  ## 
  let valid = call_568218.validator(path, query, header, formData, body)
  let scheme = call_568218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568218.url(scheme.get, call_568218.host, call_568218.base,
                         call_568218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568218, url, valid)

proc call*(call_568219: Call_VirtualMachineImagesListPublishers_568212;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## virtualMachineImagesListPublishers
  ## Gets a list of virtual machine image publishers for the specified Azure location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_568220 = newJObject()
  var query_568221 = newJObject()
  add(query_568221, "api-version", newJString(apiVersion))
  add(path_568220, "subscriptionId", newJString(subscriptionId))
  add(path_568220, "location", newJString(location))
  result = call_568219.call(path_568220, query_568221, nil, nil, nil)

var virtualMachineImagesListPublishers* = Call_VirtualMachineImagesListPublishers_568212(
    name: "virtualMachineImagesListPublishers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers",
    validator: validate_VirtualMachineImagesListPublishers_568213, base: "",
    url: url_VirtualMachineImagesListPublishers_568214, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesListTypes_568222 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionImagesListTypes_568224(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisherName" in path, "`publisherName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherName"), (
        kind: ConstantSegment, value: "/artifacttypes/vmextension/types")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineExtensionImagesListTypes_568223(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual machine extension image types.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: JString (required)
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568225 = path.getOrDefault("subscriptionId")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "subscriptionId", valid_568225
  var valid_568226 = path.getOrDefault("publisherName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "publisherName", valid_568226
  var valid_568227 = path.getOrDefault("location")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "location", valid_568227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568228 = query.getOrDefault("api-version")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "api-version", valid_568228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568229: Call_VirtualMachineExtensionImagesListTypes_568222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine extension image types.
  ## 
  let valid = call_568229.validator(path, query, header, formData, body)
  let scheme = call_568229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568229.url(scheme.get, call_568229.host, call_568229.base,
                         call_568229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568229, url, valid)

proc call*(call_568230: Call_VirtualMachineExtensionImagesListTypes_568222;
          apiVersion: string; subscriptionId: string; publisherName: string;
          location: string): Recallable =
  ## virtualMachineExtensionImagesListTypes
  ## Gets a list of virtual machine extension image types.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: string (required)
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_568231 = newJObject()
  var query_568232 = newJObject()
  add(query_568232, "api-version", newJString(apiVersion))
  add(path_568231, "subscriptionId", newJString(subscriptionId))
  add(path_568231, "publisherName", newJString(publisherName))
  add(path_568231, "location", newJString(location))
  result = call_568230.call(path_568231, query_568232, nil, nil, nil)

var virtualMachineExtensionImagesListTypes* = Call_VirtualMachineExtensionImagesListTypes_568222(
    name: "virtualMachineExtensionImagesListTypes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types",
    validator: validate_VirtualMachineExtensionImagesListTypes_568223, base: "",
    url: url_VirtualMachineExtensionImagesListTypes_568224,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesListVersions_568233 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionImagesListVersions_568235(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisherName" in path, "`publisherName` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherName"), (
        kind: ConstantSegment, value: "/artifacttypes/vmextension/types/"),
               (kind: VariableSegment, value: "type"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineExtensionImagesListVersions_568234(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual machine extension image versions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: JString (required)
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_568236 = path.getOrDefault("type")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "type", valid_568236
  var valid_568237 = path.getOrDefault("subscriptionId")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "subscriptionId", valid_568237
  var valid_568238 = path.getOrDefault("publisherName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "publisherName", valid_568238
  var valid_568239 = path.getOrDefault("location")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "location", valid_568239
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_568240 = query.getOrDefault("$orderby")
  valid_568240 = validateParameter(valid_568240, JString, required = false,
                                 default = nil)
  if valid_568240 != nil:
    section.add "$orderby", valid_568240
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "api-version", valid_568241
  var valid_568242 = query.getOrDefault("$top")
  valid_568242 = validateParameter(valid_568242, JInt, required = false, default = nil)
  if valid_568242 != nil:
    section.add "$top", valid_568242
  var valid_568243 = query.getOrDefault("$filter")
  valid_568243 = validateParameter(valid_568243, JString, required = false,
                                 default = nil)
  if valid_568243 != nil:
    section.add "$filter", valid_568243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_VirtualMachineExtensionImagesListVersions_568233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine extension image versions.
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_VirtualMachineExtensionImagesListVersions_568233;
          `type`: string; apiVersion: string; subscriptionId: string;
          publisherName: string; location: string; Orderby: string = ""; Top: int = 0;
          Filter: string = ""): Recallable =
  ## virtualMachineExtensionImagesListVersions
  ## Gets a list of virtual machine extension image versions.
  ##   type: string (required)
  ##   Orderby: string
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##   publisherName: string (required)
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  add(path_568246, "type", newJString(`type`))
  add(query_568247, "$orderby", newJString(Orderby))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  add(query_568247, "$top", newJInt(Top))
  add(path_568246, "publisherName", newJString(publisherName))
  add(path_568246, "location", newJString(location))
  add(query_568247, "$filter", newJString(Filter))
  result = call_568245.call(path_568246, query_568247, nil, nil, nil)

var virtualMachineExtensionImagesListVersions* = Call_VirtualMachineExtensionImagesListVersions_568233(
    name: "virtualMachineExtensionImagesListVersions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions",
    validator: validate_VirtualMachineExtensionImagesListVersions_568234,
    base: "", url: url_VirtualMachineExtensionImagesListVersions_568235,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesGet_568248 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionImagesGet_568250(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisherName" in path, "`publisherName` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherName"), (
        kind: ConstantSegment, value: "/artifacttypes/vmextension/types/"),
               (kind: VariableSegment, value: "type"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineExtensionImagesGet_568249(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a virtual machine extension image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##   version: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: JString (required)
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_568251 = path.getOrDefault("type")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "type", valid_568251
  var valid_568252 = path.getOrDefault("version")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "version", valid_568252
  var valid_568253 = path.getOrDefault("subscriptionId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "subscriptionId", valid_568253
  var valid_568254 = path.getOrDefault("publisherName")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "publisherName", valid_568254
  var valid_568255 = path.getOrDefault("location")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "location", valid_568255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568256 = query.getOrDefault("api-version")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "api-version", valid_568256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568257: Call_VirtualMachineExtensionImagesGet_568248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a virtual machine extension image.
  ## 
  let valid = call_568257.validator(path, query, header, formData, body)
  let scheme = call_568257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568257.url(scheme.get, call_568257.host, call_568257.base,
                         call_568257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568257, url, valid)

proc call*(call_568258: Call_VirtualMachineExtensionImagesGet_568248;
          `type`: string; apiVersion: string; version: string; subscriptionId: string;
          publisherName: string; location: string): Recallable =
  ## virtualMachineExtensionImagesGet
  ## Gets a virtual machine extension image.
  ##   type: string (required)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   version: string (required)
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: string (required)
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_568259 = newJObject()
  var query_568260 = newJObject()
  add(path_568259, "type", newJString(`type`))
  add(query_568260, "api-version", newJString(apiVersion))
  add(path_568259, "version", newJString(version))
  add(path_568259, "subscriptionId", newJString(subscriptionId))
  add(path_568259, "publisherName", newJString(publisherName))
  add(path_568259, "location", newJString(location))
  result = call_568258.call(path_568259, query_568260, nil, nil, nil)

var virtualMachineExtensionImagesGet* = Call_VirtualMachineExtensionImagesGet_568248(
    name: "virtualMachineExtensionImagesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions/{version}",
    validator: validate_VirtualMachineExtensionImagesGet_568249, base: "",
    url: url_VirtualMachineExtensionImagesGet_568250, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListOffers_568261 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineImagesListOffers_568263(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisherName" in path, "`publisherName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherName"),
               (kind: ConstantSegment, value: "/artifacttypes/vmimage/offers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImagesListOffers_568262(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual machine image offers for the specified location and publisher.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: JString (required)
  ##                : A valid image publisher.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568264 = path.getOrDefault("subscriptionId")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "subscriptionId", valid_568264
  var valid_568265 = path.getOrDefault("publisherName")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "publisherName", valid_568265
  var valid_568266 = path.getOrDefault("location")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "location", valid_568266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568267 = query.getOrDefault("api-version")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "api-version", valid_568267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_VirtualMachineImagesListOffers_568261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of virtual machine image offers for the specified location and publisher.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_VirtualMachineImagesListOffers_568261;
          apiVersion: string; subscriptionId: string; publisherName: string;
          location: string): Recallable =
  ## virtualMachineImagesListOffers
  ## Gets a list of virtual machine image offers for the specified location and publisher.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: string (required)
  ##                : A valid image publisher.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "subscriptionId", newJString(subscriptionId))
  add(path_568270, "publisherName", newJString(publisherName))
  add(path_568270, "location", newJString(location))
  result = call_568269.call(path_568270, query_568271, nil, nil, nil)

var virtualMachineImagesListOffers* = Call_VirtualMachineImagesListOffers_568261(
    name: "virtualMachineImagesListOffers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers",
    validator: validate_VirtualMachineImagesListOffers_568262, base: "",
    url: url_VirtualMachineImagesListOffers_568263, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListSkus_568272 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineImagesListSkus_568274(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisherName" in path, "`publisherName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherName"), (
        kind: ConstantSegment, value: "/artifacttypes/vmimage/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImagesListSkus_568273(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: JString (required)
  ##                : A valid image publisher.
  ##   offer: JString (required)
  ##        : A valid image publisher offer.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568275 = path.getOrDefault("subscriptionId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "subscriptionId", valid_568275
  var valid_568276 = path.getOrDefault("publisherName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "publisherName", valid_568276
  var valid_568277 = path.getOrDefault("offer")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "offer", valid_568277
  var valid_568278 = path.getOrDefault("location")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "location", valid_568278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_568280: Call_VirtualMachineImagesListSkus_568272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
  ## 
  let valid = call_568280.validator(path, query, header, formData, body)
  let scheme = call_568280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568280.url(scheme.get, call_568280.host, call_568280.base,
                         call_568280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568280, url, valid)

proc call*(call_568281: Call_VirtualMachineImagesListSkus_568272;
          apiVersion: string; subscriptionId: string; publisherName: string;
          offer: string; location: string): Recallable =
  ## virtualMachineImagesListSkus
  ## Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: string (required)
  ##                : A valid image publisher.
  ##   offer: string (required)
  ##        : A valid image publisher offer.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_568282 = newJObject()
  var query_568283 = newJObject()
  add(query_568283, "api-version", newJString(apiVersion))
  add(path_568282, "subscriptionId", newJString(subscriptionId))
  add(path_568282, "publisherName", newJString(publisherName))
  add(path_568282, "offer", newJString(offer))
  add(path_568282, "location", newJString(location))
  result = call_568281.call(path_568282, query_568283, nil, nil, nil)

var virtualMachineImagesListSkus* = Call_VirtualMachineImagesListSkus_568272(
    name: "virtualMachineImagesListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus",
    validator: validate_VirtualMachineImagesListSkus_568273, base: "",
    url: url_VirtualMachineImagesListSkus_568274, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesList_568284 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineImagesList_568286(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisherName" in path, "`publisherName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  assert "skus" in path, "`skus` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherName"), (
        kind: ConstantSegment, value: "/artifacttypes/vmimage/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/skus/"),
               (kind: VariableSegment, value: "skus"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImagesList_568285(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all virtual machine image versions for the specified location, publisher, offer, and SKU.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skus: JString (required)
  ##       : A valid image SKU.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: JString (required)
  ##                : A valid image publisher.
  ##   offer: JString (required)
  ##        : A valid image publisher offer.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skus` field"
  var valid_568287 = path.getOrDefault("skus")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "skus", valid_568287
  var valid_568288 = path.getOrDefault("subscriptionId")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "subscriptionId", valid_568288
  var valid_568289 = path.getOrDefault("publisherName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "publisherName", valid_568289
  var valid_568290 = path.getOrDefault("offer")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "offer", valid_568290
  var valid_568291 = path.getOrDefault("location")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "location", valid_568291
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_568292 = query.getOrDefault("$orderby")
  valid_568292 = validateParameter(valid_568292, JString, required = false,
                                 default = nil)
  if valid_568292 != nil:
    section.add "$orderby", valid_568292
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568293 = query.getOrDefault("api-version")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "api-version", valid_568293
  var valid_568294 = query.getOrDefault("$top")
  valid_568294 = validateParameter(valid_568294, JInt, required = false, default = nil)
  if valid_568294 != nil:
    section.add "$top", valid_568294
  var valid_568295 = query.getOrDefault("$filter")
  valid_568295 = validateParameter(valid_568295, JString, required = false,
                                 default = nil)
  if valid_568295 != nil:
    section.add "$filter", valid_568295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568296: Call_VirtualMachineImagesList_568284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all virtual machine image versions for the specified location, publisher, offer, and SKU.
  ## 
  let valid = call_568296.validator(path, query, header, formData, body)
  let scheme = call_568296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568296.url(scheme.get, call_568296.host, call_568296.base,
                         call_568296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568296, url, valid)

proc call*(call_568297: Call_VirtualMachineImagesList_568284; apiVersion: string;
          skus: string; subscriptionId: string; publisherName: string; offer: string;
          location: string; Orderby: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## virtualMachineImagesList
  ## Gets a list of all virtual machine image versions for the specified location, publisher, offer, and SKU.
  ##   Orderby: string
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skus: string (required)
  ##       : A valid image SKU.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##   publisherName: string (required)
  ##                : A valid image publisher.
  ##   offer: string (required)
  ##        : A valid image publisher offer.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568298 = newJObject()
  var query_568299 = newJObject()
  add(query_568299, "$orderby", newJString(Orderby))
  add(query_568299, "api-version", newJString(apiVersion))
  add(path_568298, "skus", newJString(skus))
  add(path_568298, "subscriptionId", newJString(subscriptionId))
  add(query_568299, "$top", newJInt(Top))
  add(path_568298, "publisherName", newJString(publisherName))
  add(path_568298, "offer", newJString(offer))
  add(path_568298, "location", newJString(location))
  add(query_568299, "$filter", newJString(Filter))
  result = call_568297.call(path_568298, query_568299, nil, nil, nil)

var virtualMachineImagesList* = Call_VirtualMachineImagesList_568284(
    name: "virtualMachineImagesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions",
    validator: validate_VirtualMachineImagesList_568285, base: "",
    url: url_VirtualMachineImagesList_568286, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesGet_568300 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineImagesGet_568302(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisherName" in path, "`publisherName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  assert "skus" in path, "`skus` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherName"), (
        kind: ConstantSegment, value: "/artifacttypes/vmimage/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/skus/"),
               (kind: VariableSegment, value: "skus"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImagesGet_568301(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a virtual machine image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skus: JString (required)
  ##       : A valid image SKU.
  ##   version: JString (required)
  ##          : A valid image SKU version.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: JString (required)
  ##                : A valid image publisher.
  ##   offer: JString (required)
  ##        : A valid image publisher offer.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skus` field"
  var valid_568303 = path.getOrDefault("skus")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "skus", valid_568303
  var valid_568304 = path.getOrDefault("version")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "version", valid_568304
  var valid_568305 = path.getOrDefault("subscriptionId")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "subscriptionId", valid_568305
  var valid_568306 = path.getOrDefault("publisherName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "publisherName", valid_568306
  var valid_568307 = path.getOrDefault("offer")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "offer", valid_568307
  var valid_568308 = path.getOrDefault("location")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "location", valid_568308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568309 = query.getOrDefault("api-version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "api-version", valid_568309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568310: Call_VirtualMachineImagesGet_568300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual machine image.
  ## 
  let valid = call_568310.validator(path, query, header, formData, body)
  let scheme = call_568310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568310.url(scheme.get, call_568310.host, call_568310.base,
                         call_568310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568310, url, valid)

proc call*(call_568311: Call_VirtualMachineImagesGet_568300; apiVersion: string;
          skus: string; version: string; subscriptionId: string;
          publisherName: string; offer: string; location: string): Recallable =
  ## virtualMachineImagesGet
  ## Gets a virtual machine image.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skus: string (required)
  ##       : A valid image SKU.
  ##   version: string (required)
  ##          : A valid image SKU version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: string (required)
  ##                : A valid image publisher.
  ##   offer: string (required)
  ##        : A valid image publisher offer.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_568312 = newJObject()
  var query_568313 = newJObject()
  add(query_568313, "api-version", newJString(apiVersion))
  add(path_568312, "skus", newJString(skus))
  add(path_568312, "version", newJString(version))
  add(path_568312, "subscriptionId", newJString(subscriptionId))
  add(path_568312, "publisherName", newJString(publisherName))
  add(path_568312, "offer", newJString(offer))
  add(path_568312, "location", newJString(location))
  result = call_568311.call(path_568312, query_568313, nil, nil, nil)

var virtualMachineImagesGet* = Call_VirtualMachineImagesGet_568300(
    name: "virtualMachineImagesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions/{version}",
    validator: validate_VirtualMachineImagesGet_568301, base: "",
    url: url_VirtualMachineImagesGet_568302, schemes: {Scheme.Https})
type
  Call_UsageList_568314 = ref object of OpenApiRestCall_567667
proc url_UsageList_568316(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageList_568315(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location for which resource usage is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568317 = path.getOrDefault("subscriptionId")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "subscriptionId", valid_568317
  var valid_568318 = path.getOrDefault("location")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "location", valid_568318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568319 = query.getOrDefault("api-version")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "api-version", valid_568319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568320: Call_UsageList_568314; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
  ## 
  let valid = call_568320.validator(path, query, header, formData, body)
  let scheme = call_568320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568320.url(scheme.get, call_568320.host, call_568320.base,
                         call_568320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568320, url, valid)

proc call*(call_568321: Call_UsageList_568314; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usageList
  ## Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location for which resource usage is queried.
  var path_568322 = newJObject()
  var query_568323 = newJObject()
  add(query_568323, "api-version", newJString(apiVersion))
  add(path_568322, "subscriptionId", newJString(subscriptionId))
  add(path_568322, "location", newJString(location))
  result = call_568321.call(path_568322, query_568323, nil, nil, nil)

var usageList* = Call_UsageList_568314(name: "usageList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/usages",
                                    validator: validate_UsageList_568315,
                                    base: "", url: url_UsageList_568316,
                                    schemes: {Scheme.Https})
type
  Call_VirtualMachinesListByLocation_568324 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesListByLocation_568326(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/virtualMachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesListByLocation_568325(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the virtual machines under the specified subscription for the specified location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location for which virtual machines under the subscription are queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568327 = path.getOrDefault("subscriptionId")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "subscriptionId", valid_568327
  var valid_568328 = path.getOrDefault("location")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "location", valid_568328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568329 = query.getOrDefault("api-version")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "api-version", valid_568329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568330: Call_VirtualMachinesListByLocation_568324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the virtual machines under the specified subscription for the specified location.
  ## 
  let valid = call_568330.validator(path, query, header, formData, body)
  let scheme = call_568330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568330.url(scheme.get, call_568330.host, call_568330.base,
                         call_568330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568330, url, valid)

proc call*(call_568331: Call_VirtualMachinesListByLocation_568324;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## virtualMachinesListByLocation
  ## Gets all the virtual machines under the specified subscription for the specified location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location for which virtual machines under the subscription are queried.
  var path_568332 = newJObject()
  var query_568333 = newJObject()
  add(query_568333, "api-version", newJString(apiVersion))
  add(path_568332, "subscriptionId", newJString(subscriptionId))
  add(path_568332, "location", newJString(location))
  result = call_568331.call(path_568332, query_568333, nil, nil, nil)

var virtualMachinesListByLocation* = Call_VirtualMachinesListByLocation_568324(
    name: "virtualMachinesListByLocation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/virtualMachines",
    validator: validate_VirtualMachinesListByLocation_568325, base: "",
    url: url_VirtualMachinesListByLocation_568326, schemes: {Scheme.Https})
type
  Call_VirtualMachineSizesList_568334 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineSizesList_568336(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/vmSizes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSizesList_568335(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all available virtual machine sizes for a subscription in a location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568337 = path.getOrDefault("subscriptionId")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "subscriptionId", valid_568337
  var valid_568338 = path.getOrDefault("location")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "location", valid_568338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568339 = query.getOrDefault("api-version")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "api-version", valid_568339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568340: Call_VirtualMachineSizesList_568334; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes for a subscription in a location.
  ## 
  let valid = call_568340.validator(path, query, header, formData, body)
  let scheme = call_568340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568340.url(scheme.get, call_568340.host, call_568340.base,
                         call_568340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568340, url, valid)

proc call*(call_568341: Call_VirtualMachineSizesList_568334; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## virtualMachineSizesList
  ## Lists all available virtual machine sizes for a subscription in a location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  var path_568342 = newJObject()
  var query_568343 = newJObject()
  add(query_568343, "api-version", newJString(apiVersion))
  add(path_568342, "subscriptionId", newJString(subscriptionId))
  add(path_568342, "location", newJString(location))
  result = call_568341.call(path_568342, query_568343, nil, nil, nil)

var virtualMachineSizesList* = Call_VirtualMachineSizesList_568334(
    name: "virtualMachineSizesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/vmSizes",
    validator: validate_VirtualMachineSizesList_568335, base: "",
    url: url_VirtualMachineSizesList_568336, schemes: {Scheme.Https})
type
  Call_ResourceSkusList_568344 = ref object of OpenApiRestCall_567667
proc url_ResourceSkusList_568346(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceSkusList_568345(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the list of Microsoft.Compute SKUs available for your Subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568347 = path.getOrDefault("subscriptionId")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "subscriptionId", valid_568347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568348 = query.getOrDefault("api-version")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "api-version", valid_568348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568349: Call_ResourceSkusList_568344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Microsoft.Compute SKUs available for your Subscription.
  ## 
  let valid = call_568349.validator(path, query, header, formData, body)
  let scheme = call_568349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568349.url(scheme.get, call_568349.host, call_568349.base,
                         call_568349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568349, url, valid)

proc call*(call_568350: Call_ResourceSkusList_568344; apiVersion: string;
          subscriptionId: string): Recallable =
  ## resourceSkusList
  ## Gets the list of Microsoft.Compute SKUs available for your Subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568351 = newJObject()
  var query_568352 = newJObject()
  add(query_568352, "api-version", newJString(apiVersion))
  add(path_568351, "subscriptionId", newJString(subscriptionId))
  result = call_568350.call(path_568351, query_568352, nil, nil, nil)

var resourceSkusList* = Call_ResourceSkusList_568344(name: "resourceSkusList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/skus",
    validator: validate_ResourceSkusList_568345, base: "",
    url: url_ResourceSkusList_568346, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsListAll_568353 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsListAll_568355(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsListAll_568354(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568356 = path.getOrDefault("subscriptionId")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "subscriptionId", valid_568356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568358: Call_VirtualMachineScaleSetsListAll_568353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ## 
  let valid = call_568358.validator(path, query, header, formData, body)
  let scheme = call_568358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568358.url(scheme.get, call_568358.host, call_568358.base,
                         call_568358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568358, url, valid)

proc call*(call_568359: Call_VirtualMachineScaleSetsListAll_568353;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsListAll
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568360 = newJObject()
  var query_568361 = newJObject()
  add(query_568361, "api-version", newJString(apiVersion))
  add(path_568360, "subscriptionId", newJString(subscriptionId))
  result = call_568359.call(path_568360, query_568361, nil, nil, nil)

var virtualMachineScaleSetsListAll* = Call_VirtualMachineScaleSetsListAll_568353(
    name: "virtualMachineScaleSetsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachineScaleSets",
    validator: validate_VirtualMachineScaleSetsListAll_568354, base: "",
    url: url_VirtualMachineScaleSetsListAll_568355, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListAll_568362 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesListAll_568364(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Compute/virtualMachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesListAll_568363(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568365 = path.getOrDefault("subscriptionId")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "subscriptionId", valid_568365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "api-version", valid_568366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568367: Call_VirtualMachinesListAll_568362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  let valid = call_568367.validator(path, query, header, formData, body)
  let scheme = call_568367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568367.url(scheme.get, call_568367.host, call_568367.base,
                         call_568367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568367, url, valid)

proc call*(call_568368: Call_VirtualMachinesListAll_568362; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachinesListAll
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568369 = newJObject()
  var query_568370 = newJObject()
  add(query_568370, "api-version", newJString(apiVersion))
  add(path_568369, "subscriptionId", newJString(subscriptionId))
  result = call_568368.call(path_568369, query_568370, nil, nil, nil)

var virtualMachinesListAll* = Call_VirtualMachinesListAll_568362(
    name: "virtualMachinesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachines",
    validator: validate_VirtualMachinesListAll_568363, base: "",
    url: url_VirtualMachinesListAll_568364, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsList_568371 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsList_568373(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Compute/availabilitySets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilitySetsList_568372(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all availability sets in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568374 = path.getOrDefault("resourceGroupName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "resourceGroupName", valid_568374
  var valid_568375 = path.getOrDefault("subscriptionId")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "subscriptionId", valid_568375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_568377: Call_AvailabilitySetsList_568371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all availability sets in a resource group.
  ## 
  let valid = call_568377.validator(path, query, header, formData, body)
  let scheme = call_568377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568377.url(scheme.get, call_568377.host, call_568377.base,
                         call_568377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568377, url, valid)

proc call*(call_568378: Call_AvailabilitySetsList_568371;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## availabilitySetsList
  ## Lists all availability sets in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568379 = newJObject()
  var query_568380 = newJObject()
  add(path_568379, "resourceGroupName", newJString(resourceGroupName))
  add(query_568380, "api-version", newJString(apiVersion))
  add(path_568379, "subscriptionId", newJString(subscriptionId))
  result = call_568378.call(path_568379, query_568380, nil, nil, nil)

var availabilitySetsList* = Call_AvailabilitySetsList_568371(
    name: "availabilitySetsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets",
    validator: validate_AvailabilitySetsList_568372, base: "",
    url: url_AvailabilitySetsList_568373, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsCreateOrUpdate_568392 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsCreateOrUpdate_568394(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "availabilitySetName" in path,
        "`availabilitySetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/availabilitySets/"),
               (kind: VariableSegment, value: "availabilitySetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilitySetsCreateOrUpdate_568393(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an availability set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: JString (required)
  ##                      : The name of the availability set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568412 = path.getOrDefault("resourceGroupName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "resourceGroupName", valid_568412
  var valid_568413 = path.getOrDefault("subscriptionId")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "subscriptionId", valid_568413
  var valid_568414 = path.getOrDefault("availabilitySetName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "availabilitySetName", valid_568414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Availability Set operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568417: Call_AvailabilitySetsCreateOrUpdate_568392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an availability set.
  ## 
  let valid = call_568417.validator(path, query, header, formData, body)
  let scheme = call_568417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568417.url(scheme.get, call_568417.host, call_568417.base,
                         call_568417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568417, url, valid)

proc call*(call_568418: Call_AvailabilitySetsCreateOrUpdate_568392;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          availabilitySetName: string; parameters: JsonNode): Recallable =
  ## availabilitySetsCreateOrUpdate
  ## Create or update an availability set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: string (required)
  ##                      : The name of the availability set.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Availability Set operation.
  var path_568419 = newJObject()
  var query_568420 = newJObject()
  var body_568421 = newJObject()
  add(path_568419, "resourceGroupName", newJString(resourceGroupName))
  add(query_568420, "api-version", newJString(apiVersion))
  add(path_568419, "subscriptionId", newJString(subscriptionId))
  add(path_568419, "availabilitySetName", newJString(availabilitySetName))
  if parameters != nil:
    body_568421 = parameters
  result = call_568418.call(path_568419, query_568420, nil, nil, body_568421)

var availabilitySetsCreateOrUpdate* = Call_AvailabilitySetsCreateOrUpdate_568392(
    name: "availabilitySetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsCreateOrUpdate_568393, base: "",
    url: url_AvailabilitySetsCreateOrUpdate_568394, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsGet_568381 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsGet_568383(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "availabilitySetName" in path,
        "`availabilitySetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/availabilitySets/"),
               (kind: VariableSegment, value: "availabilitySetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilitySetsGet_568382(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves information about an availability set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: JString (required)
  ##                      : The name of the availability set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568384 = path.getOrDefault("resourceGroupName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "resourceGroupName", valid_568384
  var valid_568385 = path.getOrDefault("subscriptionId")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "subscriptionId", valid_568385
  var valid_568386 = path.getOrDefault("availabilitySetName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "availabilitySetName", valid_568386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "api-version", valid_568387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568388: Call_AvailabilitySetsGet_568381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about an availability set.
  ## 
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_AvailabilitySetsGet_568381; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; availabilitySetName: string): Recallable =
  ## availabilitySetsGet
  ## Retrieves information about an availability set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: string (required)
  ##                      : The name of the availability set.
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  add(path_568390, "resourceGroupName", newJString(resourceGroupName))
  add(query_568391, "api-version", newJString(apiVersion))
  add(path_568390, "subscriptionId", newJString(subscriptionId))
  add(path_568390, "availabilitySetName", newJString(availabilitySetName))
  result = call_568389.call(path_568390, query_568391, nil, nil, nil)

var availabilitySetsGet* = Call_AvailabilitySetsGet_568381(
    name: "availabilitySetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsGet_568382, base: "",
    url: url_AvailabilitySetsGet_568383, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsDelete_568422 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsDelete_568424(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "availabilitySetName" in path,
        "`availabilitySetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/availabilitySets/"),
               (kind: VariableSegment, value: "availabilitySetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilitySetsDelete_568423(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an availability set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: JString (required)
  ##                      : The name of the availability set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568425 = path.getOrDefault("resourceGroupName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "resourceGroupName", valid_568425
  var valid_568426 = path.getOrDefault("subscriptionId")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "subscriptionId", valid_568426
  var valid_568427 = path.getOrDefault("availabilitySetName")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "availabilitySetName", valid_568427
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568428 = query.getOrDefault("api-version")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "api-version", valid_568428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568429: Call_AvailabilitySetsDelete_568422; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an availability set.
  ## 
  let valid = call_568429.validator(path, query, header, formData, body)
  let scheme = call_568429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568429.url(scheme.get, call_568429.host, call_568429.base,
                         call_568429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568429, url, valid)

proc call*(call_568430: Call_AvailabilitySetsDelete_568422;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          availabilitySetName: string): Recallable =
  ## availabilitySetsDelete
  ## Delete an availability set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: string (required)
  ##                      : The name of the availability set.
  var path_568431 = newJObject()
  var query_568432 = newJObject()
  add(path_568431, "resourceGroupName", newJString(resourceGroupName))
  add(query_568432, "api-version", newJString(apiVersion))
  add(path_568431, "subscriptionId", newJString(subscriptionId))
  add(path_568431, "availabilitySetName", newJString(availabilitySetName))
  result = call_568430.call(path_568431, query_568432, nil, nil, nil)

var availabilitySetsDelete* = Call_AvailabilitySetsDelete_568422(
    name: "availabilitySetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsDelete_568423, base: "",
    url: url_AvailabilitySetsDelete_568424, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsListAvailableSizes_568433 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsListAvailableSizes_568435(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "availabilitySetName" in path,
        "`availabilitySetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/availabilitySets/"),
               (kind: VariableSegment, value: "availabilitySetName"),
               (kind: ConstantSegment, value: "/vmSizes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilitySetsListAvailableSizes_568434(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all available virtual machine sizes that can be used to create a new virtual machine in an existing availability set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: JString (required)
  ##                      : The name of the availability set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568436 = path.getOrDefault("resourceGroupName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "resourceGroupName", valid_568436
  var valid_568437 = path.getOrDefault("subscriptionId")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "subscriptionId", valid_568437
  var valid_568438 = path.getOrDefault("availabilitySetName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "availabilitySetName", valid_568438
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568439 = query.getOrDefault("api-version")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "api-version", valid_568439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568440: Call_AvailabilitySetsListAvailableSizes_568433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes that can be used to create a new virtual machine in an existing availability set.
  ## 
  let valid = call_568440.validator(path, query, header, formData, body)
  let scheme = call_568440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568440.url(scheme.get, call_568440.host, call_568440.base,
                         call_568440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568440, url, valid)

proc call*(call_568441: Call_AvailabilitySetsListAvailableSizes_568433;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          availabilitySetName: string): Recallable =
  ## availabilitySetsListAvailableSizes
  ## Lists all available virtual machine sizes that can be used to create a new virtual machine in an existing availability set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: string (required)
  ##                      : The name of the availability set.
  var path_568442 = newJObject()
  var query_568443 = newJObject()
  add(path_568442, "resourceGroupName", newJString(resourceGroupName))
  add(query_568443, "api-version", newJString(apiVersion))
  add(path_568442, "subscriptionId", newJString(subscriptionId))
  add(path_568442, "availabilitySetName", newJString(availabilitySetName))
  result = call_568441.call(path_568442, query_568443, nil, nil, nil)

var availabilitySetsListAvailableSizes* = Call_AvailabilitySetsListAvailableSizes_568433(
    name: "availabilitySetsListAvailableSizes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}/vmSizes",
    validator: validate_AvailabilitySetsListAvailableSizes_568434, base: "",
    url: url_AvailabilitySetsListAvailableSizes_568435, schemes: {Scheme.Https})
type
  Call_ImagesListByResourceGroup_568444 = ref object of OpenApiRestCall_567667
proc url_ImagesListByResourceGroup_568446(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/images")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImagesListByResourceGroup_568445(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of images under a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568447 = path.getOrDefault("resourceGroupName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "resourceGroupName", valid_568447
  var valid_568448 = path.getOrDefault("subscriptionId")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "subscriptionId", valid_568448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568449 = query.getOrDefault("api-version")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "api-version", valid_568449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568450: Call_ImagesListByResourceGroup_568444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of images under a resource group.
  ## 
  let valid = call_568450.validator(path, query, header, formData, body)
  let scheme = call_568450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568450.url(scheme.get, call_568450.host, call_568450.base,
                         call_568450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568450, url, valid)

proc call*(call_568451: Call_ImagesListByResourceGroup_568444;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## imagesListByResourceGroup
  ## Gets the list of images under a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568452 = newJObject()
  var query_568453 = newJObject()
  add(path_568452, "resourceGroupName", newJString(resourceGroupName))
  add(query_568453, "api-version", newJString(apiVersion))
  add(path_568452, "subscriptionId", newJString(subscriptionId))
  result = call_568451.call(path_568452, query_568453, nil, nil, nil)

var imagesListByResourceGroup* = Call_ImagesListByResourceGroup_568444(
    name: "imagesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images",
    validator: validate_ImagesListByResourceGroup_568445, base: "",
    url: url_ImagesListByResourceGroup_568446, schemes: {Scheme.Https})
type
  Call_ImagesCreateOrUpdate_568466 = ref object of OpenApiRestCall_567667
proc url_ImagesCreateOrUpdate_568468(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageName" in path, "`imageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/images/"),
               (kind: VariableSegment, value: "imageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImagesCreateOrUpdate_568467(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   imageName: JString (required)
  ##            : The name of the image.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568469 = path.getOrDefault("resourceGroupName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "resourceGroupName", valid_568469
  var valid_568470 = path.getOrDefault("subscriptionId")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "subscriptionId", valid_568470
  var valid_568471 = path.getOrDefault("imageName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "imageName", valid_568471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568472 = query.getOrDefault("api-version")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "api-version", valid_568472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Image operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568474: Call_ImagesCreateOrUpdate_568466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an image.
  ## 
  let valid = call_568474.validator(path, query, header, formData, body)
  let scheme = call_568474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568474.url(scheme.get, call_568474.host, call_568474.base,
                         call_568474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568474, url, valid)

proc call*(call_568475: Call_ImagesCreateOrUpdate_568466;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          imageName: string; parameters: JsonNode): Recallable =
  ## imagesCreateOrUpdate
  ## Create or update an image.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   imageName: string (required)
  ##            : The name of the image.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Image operation.
  var path_568476 = newJObject()
  var query_568477 = newJObject()
  var body_568478 = newJObject()
  add(path_568476, "resourceGroupName", newJString(resourceGroupName))
  add(query_568477, "api-version", newJString(apiVersion))
  add(path_568476, "subscriptionId", newJString(subscriptionId))
  add(path_568476, "imageName", newJString(imageName))
  if parameters != nil:
    body_568478 = parameters
  result = call_568475.call(path_568476, query_568477, nil, nil, body_568478)

var imagesCreateOrUpdate* = Call_ImagesCreateOrUpdate_568466(
    name: "imagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesCreateOrUpdate_568467, base: "",
    url: url_ImagesCreateOrUpdate_568468, schemes: {Scheme.Https})
type
  Call_ImagesGet_568454 = ref object of OpenApiRestCall_567667
proc url_ImagesGet_568456(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageName" in path, "`imageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/images/"),
               (kind: VariableSegment, value: "imageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImagesGet_568455(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   imageName: JString (required)
  ##            : The name of the image.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568457 = path.getOrDefault("resourceGroupName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "resourceGroupName", valid_568457
  var valid_568458 = path.getOrDefault("subscriptionId")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "subscriptionId", valid_568458
  var valid_568459 = path.getOrDefault("imageName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "imageName", valid_568459
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568460 = query.getOrDefault("$expand")
  valid_568460 = validateParameter(valid_568460, JString, required = false,
                                 default = nil)
  if valid_568460 != nil:
    section.add "$expand", valid_568460
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568461 = query.getOrDefault("api-version")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "api-version", valid_568461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568462: Call_ImagesGet_568454; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an image.
  ## 
  let valid = call_568462.validator(path, query, header, formData, body)
  let scheme = call_568462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568462.url(scheme.get, call_568462.host, call_568462.base,
                         call_568462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568462, url, valid)

proc call*(call_568463: Call_ImagesGet_568454; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; imageName: string;
          Expand: string = ""): Recallable =
  ## imagesGet
  ## Gets an image.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   imageName: string (required)
  ##            : The name of the image.
  var path_568464 = newJObject()
  var query_568465 = newJObject()
  add(path_568464, "resourceGroupName", newJString(resourceGroupName))
  add(query_568465, "$expand", newJString(Expand))
  add(query_568465, "api-version", newJString(apiVersion))
  add(path_568464, "subscriptionId", newJString(subscriptionId))
  add(path_568464, "imageName", newJString(imageName))
  result = call_568463.call(path_568464, query_568465, nil, nil, nil)

var imagesGet* = Call_ImagesGet_568454(name: "imagesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
                                    validator: validate_ImagesGet_568455,
                                    base: "", url: url_ImagesGet_568456,
                                    schemes: {Scheme.Https})
type
  Call_ImagesDelete_568479 = ref object of OpenApiRestCall_567667
proc url_ImagesDelete_568481(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageName" in path, "`imageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/images/"),
               (kind: VariableSegment, value: "imageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImagesDelete_568480(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an Image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   imageName: JString (required)
  ##            : The name of the image.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568482 = path.getOrDefault("resourceGroupName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "resourceGroupName", valid_568482
  var valid_568483 = path.getOrDefault("subscriptionId")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "subscriptionId", valid_568483
  var valid_568484 = path.getOrDefault("imageName")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "imageName", valid_568484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568485 = query.getOrDefault("api-version")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "api-version", valid_568485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568486: Call_ImagesDelete_568479; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Image.
  ## 
  let valid = call_568486.validator(path, query, header, formData, body)
  let scheme = call_568486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568486.url(scheme.get, call_568486.host, call_568486.base,
                         call_568486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568486, url, valid)

proc call*(call_568487: Call_ImagesDelete_568479; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; imageName: string): Recallable =
  ## imagesDelete
  ## Deletes an Image.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   imageName: string (required)
  ##            : The name of the image.
  var path_568488 = newJObject()
  var query_568489 = newJObject()
  add(path_568488, "resourceGroupName", newJString(resourceGroupName))
  add(query_568489, "api-version", newJString(apiVersion))
  add(path_568488, "subscriptionId", newJString(subscriptionId))
  add(path_568488, "imageName", newJString(imageName))
  result = call_568487.call(path_568488, query_568489, nil, nil, nil)

var imagesDelete* = Call_ImagesDelete_568479(name: "imagesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesDelete_568480, base: "", url: url_ImagesDelete_568481,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsList_568490 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsList_568492(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsList_568491(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all VM scale sets under a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568493 = path.getOrDefault("resourceGroupName")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "resourceGroupName", valid_568493
  var valid_568494 = path.getOrDefault("subscriptionId")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "subscriptionId", valid_568494
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568495 = query.getOrDefault("api-version")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "api-version", valid_568495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568496: Call_VirtualMachineScaleSetsList_568490; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all VM scale sets under a resource group.
  ## 
  let valid = call_568496.validator(path, query, header, formData, body)
  let scheme = call_568496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568496.url(scheme.get, call_568496.host, call_568496.base,
                         call_568496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568496, url, valid)

proc call*(call_568497: Call_VirtualMachineScaleSetsList_568490;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsList
  ## Gets a list of all VM scale sets under a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568498 = newJObject()
  var query_568499 = newJObject()
  add(path_568498, "resourceGroupName", newJString(resourceGroupName))
  add(query_568499, "api-version", newJString(apiVersion))
  add(path_568498, "subscriptionId", newJString(subscriptionId))
  result = call_568497.call(path_568498, query_568499, nil, nil, nil)

var virtualMachineScaleSetsList* = Call_VirtualMachineScaleSetsList_568490(
    name: "virtualMachineScaleSetsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets",
    validator: validate_VirtualMachineScaleSetsList_568491, base: "",
    url: url_VirtualMachineScaleSetsList_568492, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsList_568500 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsList_568502(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineScaleSetName" in path,
        "`virtualMachineScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsList_568501(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all virtual machines in a VM scale sets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the VM scale set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568503 = path.getOrDefault("resourceGroupName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "resourceGroupName", valid_568503
  var valid_568504 = path.getOrDefault("subscriptionId")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "subscriptionId", valid_568504
  var valid_568505 = path.getOrDefault("virtualMachineScaleSetName")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "virtualMachineScaleSetName", valid_568505
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply to the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : The list parameters.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568506 = query.getOrDefault("$expand")
  valid_568506 = validateParameter(valid_568506, JString, required = false,
                                 default = nil)
  if valid_568506 != nil:
    section.add "$expand", valid_568506
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568507 = query.getOrDefault("api-version")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "api-version", valid_568507
  var valid_568508 = query.getOrDefault("$select")
  valid_568508 = validateParameter(valid_568508, JString, required = false,
                                 default = nil)
  if valid_568508 != nil:
    section.add "$select", valid_568508
  var valid_568509 = query.getOrDefault("$filter")
  valid_568509 = validateParameter(valid_568509, JString, required = false,
                                 default = nil)
  if valid_568509 != nil:
    section.add "$filter", valid_568509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568510: Call_VirtualMachineScaleSetVMsList_568500; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all virtual machines in a VM scale sets.
  ## 
  let valid = call_568510.validator(path, query, header, formData, body)
  let scheme = call_568510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568510.url(scheme.get, call_568510.host, call_568510.base,
                         call_568510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568510, url, valid)

proc call*(call_568511: Call_VirtualMachineScaleSetVMsList_568500;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualMachineScaleSetName: string; Expand: string = "";
          Select: string = ""; Filter: string = ""): Recallable =
  ## virtualMachineScaleSetVMsList
  ## Gets a list of all virtual machines in a VM scale sets.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : The expand expression to apply to the operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Select: string
  ##         : The list parameters.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the VM scale set.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568512 = newJObject()
  var query_568513 = newJObject()
  add(path_568512, "resourceGroupName", newJString(resourceGroupName))
  add(query_568513, "$expand", newJString(Expand))
  add(query_568513, "api-version", newJString(apiVersion))
  add(path_568512, "subscriptionId", newJString(subscriptionId))
  add(query_568513, "$select", newJString(Select))
  add(path_568512, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(query_568513, "$filter", newJString(Filter))
  result = call_568511.call(path_568512, query_568513, nil, nil, nil)

var virtualMachineScaleSetVMsList* = Call_VirtualMachineScaleSetVMsList_568500(
    name: "virtualMachineScaleSetVMsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines",
    validator: validate_VirtualMachineScaleSetVMsList_568501, base: "",
    url: url_VirtualMachineScaleSetVMsList_568502, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsCreateOrUpdate_568525 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsCreateOrUpdate_568527(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsCreateOrUpdate_568526(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set to create or update.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568528 = path.getOrDefault("vmScaleSetName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "vmScaleSetName", valid_568528
  var valid_568529 = path.getOrDefault("resourceGroupName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "resourceGroupName", valid_568529
  var valid_568530 = path.getOrDefault("subscriptionId")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "subscriptionId", valid_568530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568531 = query.getOrDefault("api-version")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "api-version", valid_568531
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The scale set object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568533: Call_VirtualMachineScaleSetsCreateOrUpdate_568525;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a VM scale set.
  ## 
  let valid = call_568533.validator(path, query, header, formData, body)
  let scheme = call_568533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568533.url(scheme.get, call_568533.host, call_568533.base,
                         call_568533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568533, url, valid)

proc call*(call_568534: Call_VirtualMachineScaleSetsCreateOrUpdate_568525;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## virtualMachineScaleSetsCreateOrUpdate
  ## Create or update a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set to create or update.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The scale set object.
  var path_568535 = newJObject()
  var query_568536 = newJObject()
  var body_568537 = newJObject()
  add(path_568535, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568535, "resourceGroupName", newJString(resourceGroupName))
  add(query_568536, "api-version", newJString(apiVersion))
  add(path_568535, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568537 = parameters
  result = call_568534.call(path_568535, query_568536, nil, nil, body_568537)

var virtualMachineScaleSetsCreateOrUpdate* = Call_VirtualMachineScaleSetsCreateOrUpdate_568525(
    name: "virtualMachineScaleSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsCreateOrUpdate_568526, base: "",
    url: url_VirtualMachineScaleSetsCreateOrUpdate_568527, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGet_568514 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsGet_568516(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsGet_568515(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Display information about a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568517 = path.getOrDefault("vmScaleSetName")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "vmScaleSetName", valid_568517
  var valid_568518 = path.getOrDefault("resourceGroupName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "resourceGroupName", valid_568518
  var valid_568519 = path.getOrDefault("subscriptionId")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "subscriptionId", valid_568519
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568520 = query.getOrDefault("api-version")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "api-version", valid_568520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568521: Call_VirtualMachineScaleSetsGet_568514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Display information about a virtual machine scale set.
  ## 
  let valid = call_568521.validator(path, query, header, formData, body)
  let scheme = call_568521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568521.url(scheme.get, call_568521.host, call_568521.base,
                         call_568521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568521, url, valid)

proc call*(call_568522: Call_VirtualMachineScaleSetsGet_568514;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsGet
  ## Display information about a virtual machine scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568523 = newJObject()
  var query_568524 = newJObject()
  add(path_568523, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568523, "resourceGroupName", newJString(resourceGroupName))
  add(query_568524, "api-version", newJString(apiVersion))
  add(path_568523, "subscriptionId", newJString(subscriptionId))
  result = call_568522.call(path_568523, query_568524, nil, nil, nil)

var virtualMachineScaleSetsGet* = Call_VirtualMachineScaleSetsGet_568514(
    name: "virtualMachineScaleSetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsGet_568515, base: "",
    url: url_VirtualMachineScaleSetsGet_568516, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsUpdate_568549 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsUpdate_568551(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsUpdate_568550(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set to create or update.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568552 = path.getOrDefault("vmScaleSetName")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "vmScaleSetName", valid_568552
  var valid_568553 = path.getOrDefault("resourceGroupName")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "resourceGroupName", valid_568553
  var valid_568554 = path.getOrDefault("subscriptionId")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "subscriptionId", valid_568554
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568555 = query.getOrDefault("api-version")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "api-version", valid_568555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The scale set object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568557: Call_VirtualMachineScaleSetsUpdate_568549; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a VM scale set.
  ## 
  let valid = call_568557.validator(path, query, header, formData, body)
  let scheme = call_568557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568557.url(scheme.get, call_568557.host, call_568557.base,
                         call_568557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568557, url, valid)

proc call*(call_568558: Call_VirtualMachineScaleSetsUpdate_568549;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## virtualMachineScaleSetsUpdate
  ## Update a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set to create or update.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The scale set object.
  var path_568559 = newJObject()
  var query_568560 = newJObject()
  var body_568561 = newJObject()
  add(path_568559, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568559, "resourceGroupName", newJString(resourceGroupName))
  add(query_568560, "api-version", newJString(apiVersion))
  add(path_568559, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568561 = parameters
  result = call_568558.call(path_568559, query_568560, nil, nil, body_568561)

var virtualMachineScaleSetsUpdate* = Call_VirtualMachineScaleSetsUpdate_568549(
    name: "virtualMachineScaleSetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsUpdate_568550, base: "",
    url: url_VirtualMachineScaleSetsUpdate_568551, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDelete_568538 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsDelete_568540(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsDelete_568539(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568541 = path.getOrDefault("vmScaleSetName")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "vmScaleSetName", valid_568541
  var valid_568542 = path.getOrDefault("resourceGroupName")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "resourceGroupName", valid_568542
  var valid_568543 = path.getOrDefault("subscriptionId")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "subscriptionId", valid_568543
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568544 = query.getOrDefault("api-version")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "api-version", valid_568544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568545: Call_VirtualMachineScaleSetsDelete_568538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VM scale set.
  ## 
  let valid = call_568545.validator(path, query, header, formData, body)
  let scheme = call_568545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568545.url(scheme.get, call_568545.host, call_568545.base,
                         call_568545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568545, url, valid)

proc call*(call_568546: Call_VirtualMachineScaleSetsDelete_568538;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsDelete
  ## Deletes a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568547 = newJObject()
  var query_568548 = newJObject()
  add(path_568547, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568547, "resourceGroupName", newJString(resourceGroupName))
  add(query_568548, "api-version", newJString(apiVersion))
  add(path_568547, "subscriptionId", newJString(subscriptionId))
  result = call_568546.call(path_568547, query_568548, nil, nil, nil)

var virtualMachineScaleSetsDelete* = Call_VirtualMachineScaleSetsDelete_568538(
    name: "virtualMachineScaleSetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsDelete_568539, base: "",
    url: url_VirtualMachineScaleSetsDelete_568540, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDeallocate_568562 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsDeallocate_568564(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/deallocate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsDeallocate_568563(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568565 = path.getOrDefault("vmScaleSetName")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "vmScaleSetName", valid_568565
  var valid_568566 = path.getOrDefault("resourceGroupName")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "resourceGroupName", valid_568566
  var valid_568567 = path.getOrDefault("subscriptionId")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "subscriptionId", valid_568567
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568568 = query.getOrDefault("api-version")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "api-version", valid_568568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568570: Call_VirtualMachineScaleSetsDeallocate_568562;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.
  ## 
  let valid = call_568570.validator(path, query, header, formData, body)
  let scheme = call_568570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568570.url(scheme.get, call_568570.host, call_568570.base,
                         call_568570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568570, url, valid)

proc call*(call_568571: Call_VirtualMachineScaleSetsDeallocate_568562;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsDeallocate
  ## Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568572 = newJObject()
  var query_568573 = newJObject()
  var body_568574 = newJObject()
  add(path_568572, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568572, "resourceGroupName", newJString(resourceGroupName))
  add(query_568573, "api-version", newJString(apiVersion))
  add(path_568572, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568574 = vmInstanceIDs
  result = call_568571.call(path_568572, query_568573, nil, nil, body_568574)

var virtualMachineScaleSetsDeallocate* = Call_VirtualMachineScaleSetsDeallocate_568562(
    name: "virtualMachineScaleSetsDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/deallocate",
    validator: validate_VirtualMachineScaleSetsDeallocate_568563, base: "",
    url: url_VirtualMachineScaleSetsDeallocate_568564, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDeleteInstances_568575 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsDeleteInstances_568577(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/delete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsDeleteInstances_568576(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes virtual machines in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568578 = path.getOrDefault("vmScaleSetName")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "vmScaleSetName", valid_568578
  var valid_568579 = path.getOrDefault("resourceGroupName")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "resourceGroupName", valid_568579
  var valid_568580 = path.getOrDefault("subscriptionId")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "subscriptionId", valid_568580
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568581 = query.getOrDefault("api-version")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "api-version", valid_568581
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject (required)
  ##                : A list of virtual machine instance IDs from the VM scale set.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568583: Call_VirtualMachineScaleSetsDeleteInstances_568575;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes virtual machines in a VM scale set.
  ## 
  let valid = call_568583.validator(path, query, header, formData, body)
  let scheme = call_568583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568583.url(scheme.get, call_568583.host, call_568583.base,
                         call_568583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568583, url, valid)

proc call*(call_568584: Call_VirtualMachineScaleSetsDeleteInstances_568575;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode): Recallable =
  ## virtualMachineScaleSetsDeleteInstances
  ## Deletes virtual machines in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject (required)
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568585 = newJObject()
  var query_568586 = newJObject()
  var body_568587 = newJObject()
  add(path_568585, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568585, "resourceGroupName", newJString(resourceGroupName))
  add(query_568586, "api-version", newJString(apiVersion))
  add(path_568585, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568587 = vmInstanceIDs
  result = call_568584.call(path_568585, query_568586, nil, nil, body_568587)

var virtualMachineScaleSetsDeleteInstances* = Call_VirtualMachineScaleSetsDeleteInstances_568575(
    name: "virtualMachineScaleSetsDeleteInstances", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/delete",
    validator: validate_VirtualMachineScaleSetsDeleteInstances_568576, base: "",
    url: url_VirtualMachineScaleSetsDeleteInstances_568577,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsList_568588 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsList_568590(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/extensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetExtensionsList_568589(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all extensions in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set containing the extension.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568591 = path.getOrDefault("vmScaleSetName")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "vmScaleSetName", valid_568591
  var valid_568592 = path.getOrDefault("resourceGroupName")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "resourceGroupName", valid_568592
  var valid_568593 = path.getOrDefault("subscriptionId")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "subscriptionId", valid_568593
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568594 = query.getOrDefault("api-version")
  valid_568594 = validateParameter(valid_568594, JString, required = true,
                                 default = nil)
  if valid_568594 != nil:
    section.add "api-version", valid_568594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568595: Call_VirtualMachineScaleSetExtensionsList_568588;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of all extensions in a VM scale set.
  ## 
  let valid = call_568595.validator(path, query, header, formData, body)
  let scheme = call_568595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568595.url(scheme.get, call_568595.host, call_568595.base,
                         call_568595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568595, url, valid)

proc call*(call_568596: Call_VirtualMachineScaleSetExtensionsList_568588;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetExtensionsList
  ## Gets a list of all extensions in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set containing the extension.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568597 = newJObject()
  var query_568598 = newJObject()
  add(path_568597, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568597, "resourceGroupName", newJString(resourceGroupName))
  add(query_568598, "api-version", newJString(apiVersion))
  add(path_568597, "subscriptionId", newJString(subscriptionId))
  result = call_568596.call(path_568597, query_568598, nil, nil, nil)

var virtualMachineScaleSetExtensionsList* = Call_VirtualMachineScaleSetExtensionsList_568588(
    name: "virtualMachineScaleSetExtensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions",
    validator: validate_VirtualMachineScaleSetExtensionsList_568589, base: "",
    url: url_VirtualMachineScaleSetExtensionsList_568590, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568612 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsCreateOrUpdate_568614(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "vmssExtensionName" in path,
        "`vmssExtensionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/extensions/"),
               (kind: VariableSegment, value: "vmssExtensionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetExtensionsCreateOrUpdate_568613(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to create or update an extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set where the extension should be create or updated.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmssExtensionName: JString (required)
  ##                    : The name of the VM scale set extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568615 = path.getOrDefault("vmScaleSetName")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "vmScaleSetName", valid_568615
  var valid_568616 = path.getOrDefault("resourceGroupName")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "resourceGroupName", valid_568616
  var valid_568617 = path.getOrDefault("subscriptionId")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "subscriptionId", valid_568617
  var valid_568618 = path.getOrDefault("vmssExtensionName")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "vmssExtensionName", valid_568618
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568619 = query.getOrDefault("api-version")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "api-version", valid_568619
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   extensionParameters: JObject (required)
  ##                      : Parameters supplied to the Create VM scale set Extension operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568621: Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568612;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update an extension.
  ## 
  let valid = call_568621.validator(path, query, header, formData, body)
  let scheme = call_568621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568621.url(scheme.get, call_568621.host, call_568621.base,
                         call_568621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568621, url, valid)

proc call*(call_568622: Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568612;
          vmScaleSetName: string; extensionParameters: JsonNode;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmssExtensionName: string): Recallable =
  ## virtualMachineScaleSetExtensionsCreateOrUpdate
  ## The operation to create or update an extension.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set where the extension should be create or updated.
  ##   extensionParameters: JObject (required)
  ##                      : Parameters supplied to the Create VM scale set Extension operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmssExtensionName: string (required)
  ##                    : The name of the VM scale set extension.
  var path_568623 = newJObject()
  var query_568624 = newJObject()
  var body_568625 = newJObject()
  add(path_568623, "vmScaleSetName", newJString(vmScaleSetName))
  if extensionParameters != nil:
    body_568625 = extensionParameters
  add(path_568623, "resourceGroupName", newJString(resourceGroupName))
  add(query_568624, "api-version", newJString(apiVersion))
  add(path_568623, "subscriptionId", newJString(subscriptionId))
  add(path_568623, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_568622.call(path_568623, query_568624, nil, nil, body_568625)

var virtualMachineScaleSetExtensionsCreateOrUpdate* = Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568612(
    name: "virtualMachineScaleSetExtensionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsCreateOrUpdate_568613,
    base: "", url: url_VirtualMachineScaleSetExtensionsCreateOrUpdate_568614,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsGet_568599 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsGet_568601(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "vmssExtensionName" in path,
        "`vmssExtensionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/extensions/"),
               (kind: VariableSegment, value: "vmssExtensionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetExtensionsGet_568600(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to get the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set containing the extension.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmssExtensionName: JString (required)
  ##                    : The name of the VM scale set extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568602 = path.getOrDefault("vmScaleSetName")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "vmScaleSetName", valid_568602
  var valid_568603 = path.getOrDefault("resourceGroupName")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "resourceGroupName", valid_568603
  var valid_568604 = path.getOrDefault("subscriptionId")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "subscriptionId", valid_568604
  var valid_568605 = path.getOrDefault("vmssExtensionName")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "vmssExtensionName", valid_568605
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568606 = query.getOrDefault("$expand")
  valid_568606 = validateParameter(valid_568606, JString, required = false,
                                 default = nil)
  if valid_568606 != nil:
    section.add "$expand", valid_568606
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568607 = query.getOrDefault("api-version")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = nil)
  if valid_568607 != nil:
    section.add "api-version", valid_568607
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568608: Call_VirtualMachineScaleSetExtensionsGet_568599;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to get the extension.
  ## 
  let valid = call_568608.validator(path, query, header, formData, body)
  let scheme = call_568608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568608.url(scheme.get, call_568608.host, call_568608.base,
                         call_568608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568608, url, valid)

proc call*(call_568609: Call_VirtualMachineScaleSetExtensionsGet_568599;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmssExtensionName: string; Expand: string = ""): Recallable =
  ## virtualMachineScaleSetExtensionsGet
  ## The operation to get the extension.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set containing the extension.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmssExtensionName: string (required)
  ##                    : The name of the VM scale set extension.
  var path_568610 = newJObject()
  var query_568611 = newJObject()
  add(path_568610, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568610, "resourceGroupName", newJString(resourceGroupName))
  add(query_568611, "$expand", newJString(Expand))
  add(query_568611, "api-version", newJString(apiVersion))
  add(path_568610, "subscriptionId", newJString(subscriptionId))
  add(path_568610, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_568609.call(path_568610, query_568611, nil, nil, nil)

var virtualMachineScaleSetExtensionsGet* = Call_VirtualMachineScaleSetExtensionsGet_568599(
    name: "virtualMachineScaleSetExtensionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsGet_568600, base: "",
    url: url_VirtualMachineScaleSetExtensionsGet_568601, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsDelete_568626 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsDelete_568628(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "vmssExtensionName" in path,
        "`vmssExtensionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/extensions/"),
               (kind: VariableSegment, value: "vmssExtensionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetExtensionsDelete_568627(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set where the extension should be deleted.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmssExtensionName: JString (required)
  ##                    : The name of the VM scale set extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568629 = path.getOrDefault("vmScaleSetName")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "vmScaleSetName", valid_568629
  var valid_568630 = path.getOrDefault("resourceGroupName")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "resourceGroupName", valid_568630
  var valid_568631 = path.getOrDefault("subscriptionId")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "subscriptionId", valid_568631
  var valid_568632 = path.getOrDefault("vmssExtensionName")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "vmssExtensionName", valid_568632
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568633 = query.getOrDefault("api-version")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "api-version", valid_568633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568634: Call_VirtualMachineScaleSetExtensionsDelete_568626;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete the extension.
  ## 
  let valid = call_568634.validator(path, query, header, formData, body)
  let scheme = call_568634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568634.url(scheme.get, call_568634.host, call_568634.base,
                         call_568634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568634, url, valid)

proc call*(call_568635: Call_VirtualMachineScaleSetExtensionsDelete_568626;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmssExtensionName: string): Recallable =
  ## virtualMachineScaleSetExtensionsDelete
  ## The operation to delete the extension.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set where the extension should be deleted.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmssExtensionName: string (required)
  ##                    : The name of the VM scale set extension.
  var path_568636 = newJObject()
  var query_568637 = newJObject()
  add(path_568636, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568636, "resourceGroupName", newJString(resourceGroupName))
  add(query_568637, "api-version", newJString(apiVersion))
  add(path_568636, "subscriptionId", newJString(subscriptionId))
  add(path_568636, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_568635.call(path_568636, query_568637, nil, nil, nil)

var virtualMachineScaleSetExtensionsDelete* = Call_VirtualMachineScaleSetExtensionsDelete_568626(
    name: "virtualMachineScaleSetExtensionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsDelete_568627, base: "",
    url: url_VirtualMachineScaleSetExtensionsDelete_568628,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGetInstanceView_568638 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsGetInstanceView_568640(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/instanceView")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsGetInstanceView_568639(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of a VM scale set instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568641 = path.getOrDefault("vmScaleSetName")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "vmScaleSetName", valid_568641
  var valid_568642 = path.getOrDefault("resourceGroupName")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "resourceGroupName", valid_568642
  var valid_568643 = path.getOrDefault("subscriptionId")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "subscriptionId", valid_568643
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568644 = query.getOrDefault("api-version")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "api-version", valid_568644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568645: Call_VirtualMachineScaleSetsGetInstanceView_568638;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a VM scale set instance.
  ## 
  let valid = call_568645.validator(path, query, header, formData, body)
  let scheme = call_568645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568645.url(scheme.get, call_568645.host, call_568645.base,
                         call_568645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568645, url, valid)

proc call*(call_568646: Call_VirtualMachineScaleSetsGetInstanceView_568638;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsGetInstanceView
  ## Gets the status of a VM scale set instance.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568647 = newJObject()
  var query_568648 = newJObject()
  add(path_568647, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568647, "resourceGroupName", newJString(resourceGroupName))
  add(query_568648, "api-version", newJString(apiVersion))
  add(path_568647, "subscriptionId", newJString(subscriptionId))
  result = call_568646.call(path_568647, query_568648, nil, nil, nil)

var virtualMachineScaleSetsGetInstanceView* = Call_VirtualMachineScaleSetsGetInstanceView_568638(
    name: "virtualMachineScaleSetsGetInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/instanceView",
    validator: validate_VirtualMachineScaleSetsGetInstanceView_568639, base: "",
    url: url_VirtualMachineScaleSetsGetInstanceView_568640,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsUpdateInstances_568649 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsUpdateInstances_568651(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/manualupgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsUpdateInstances_568650(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568652 = path.getOrDefault("vmScaleSetName")
  valid_568652 = validateParameter(valid_568652, JString, required = true,
                                 default = nil)
  if valid_568652 != nil:
    section.add "vmScaleSetName", valid_568652
  var valid_568653 = path.getOrDefault("resourceGroupName")
  valid_568653 = validateParameter(valid_568653, JString, required = true,
                                 default = nil)
  if valid_568653 != nil:
    section.add "resourceGroupName", valid_568653
  var valid_568654 = path.getOrDefault("subscriptionId")
  valid_568654 = validateParameter(valid_568654, JString, required = true,
                                 default = nil)
  if valid_568654 != nil:
    section.add "subscriptionId", valid_568654
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568655 = query.getOrDefault("api-version")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "api-version", valid_568655
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject (required)
  ##                : A list of virtual machine instance IDs from the VM scale set.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568657: Call_VirtualMachineScaleSetsUpdateInstances_568649;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.
  ## 
  let valid = call_568657.validator(path, query, header, formData, body)
  let scheme = call_568657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568657.url(scheme.get, call_568657.host, call_568657.base,
                         call_568657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568657, url, valid)

proc call*(call_568658: Call_VirtualMachineScaleSetsUpdateInstances_568649;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode): Recallable =
  ## virtualMachineScaleSetsUpdateInstances
  ## Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject (required)
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568659 = newJObject()
  var query_568660 = newJObject()
  var body_568661 = newJObject()
  add(path_568659, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568659, "resourceGroupName", newJString(resourceGroupName))
  add(query_568660, "api-version", newJString(apiVersion))
  add(path_568659, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568661 = vmInstanceIDs
  result = call_568658.call(path_568659, query_568660, nil, nil, body_568661)

var virtualMachineScaleSetsUpdateInstances* = Call_VirtualMachineScaleSetsUpdateInstances_568649(
    name: "virtualMachineScaleSetsUpdateInstances", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/manualupgrade",
    validator: validate_VirtualMachineScaleSetsUpdateInstances_568650, base: "",
    url: url_VirtualMachineScaleSetsUpdateInstances_568651,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568662 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568664(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/osRollingUpgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568663(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568665 = path.getOrDefault("vmScaleSetName")
  valid_568665 = validateParameter(valid_568665, JString, required = true,
                                 default = nil)
  if valid_568665 != nil:
    section.add "vmScaleSetName", valid_568665
  var valid_568666 = path.getOrDefault("resourceGroupName")
  valid_568666 = validateParameter(valid_568666, JString, required = true,
                                 default = nil)
  if valid_568666 != nil:
    section.add "resourceGroupName", valid_568666
  var valid_568667 = path.getOrDefault("subscriptionId")
  valid_568667 = validateParameter(valid_568667, JString, required = true,
                                 default = nil)
  if valid_568667 != nil:
    section.add "subscriptionId", valid_568667
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568668 = query.getOrDefault("api-version")
  valid_568668 = validateParameter(valid_568668, JString, required = true,
                                 default = nil)
  if valid_568668 != nil:
    section.add "api-version", valid_568668
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568669: Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568662;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.
  ## 
  let valid = call_568669.validator(path, query, header, formData, body)
  let scheme = call_568669.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568669.url(scheme.get, call_568669.host, call_568669.base,
                         call_568669.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568669, url, valid)

proc call*(call_568670: Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568662;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetRollingUpgradesStartOSUpgrade
  ## Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568671 = newJObject()
  var query_568672 = newJObject()
  add(path_568671, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568671, "resourceGroupName", newJString(resourceGroupName))
  add(query_568672, "api-version", newJString(apiVersion))
  add(path_568671, "subscriptionId", newJString(subscriptionId))
  result = call_568670.call(path_568671, query_568672, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesStartOSUpgrade* = Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568662(
    name: "virtualMachineScaleSetRollingUpgradesStartOSUpgrade",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osRollingUpgrade",
    validator: validate_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568663,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568664,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsPowerOff_568673 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsPowerOff_568675(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/poweroff")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsPowerOff_568674(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568676 = path.getOrDefault("vmScaleSetName")
  valid_568676 = validateParameter(valid_568676, JString, required = true,
                                 default = nil)
  if valid_568676 != nil:
    section.add "vmScaleSetName", valid_568676
  var valid_568677 = path.getOrDefault("resourceGroupName")
  valid_568677 = validateParameter(valid_568677, JString, required = true,
                                 default = nil)
  if valid_568677 != nil:
    section.add "resourceGroupName", valid_568677
  var valid_568678 = path.getOrDefault("subscriptionId")
  valid_568678 = validateParameter(valid_568678, JString, required = true,
                                 default = nil)
  if valid_568678 != nil:
    section.add "subscriptionId", valid_568678
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568679 = query.getOrDefault("api-version")
  valid_568679 = validateParameter(valid_568679, JString, required = true,
                                 default = nil)
  if valid_568679 != nil:
    section.add "api-version", valid_568679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568681: Call_VirtualMachineScaleSetsPowerOff_568673;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  let valid = call_568681.validator(path, query, header, formData, body)
  let scheme = call_568681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568681.url(scheme.get, call_568681.host, call_568681.base,
                         call_568681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568681, url, valid)

proc call*(call_568682: Call_VirtualMachineScaleSetsPowerOff_568673;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsPowerOff
  ## Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568683 = newJObject()
  var query_568684 = newJObject()
  var body_568685 = newJObject()
  add(path_568683, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568683, "resourceGroupName", newJString(resourceGroupName))
  add(query_568684, "api-version", newJString(apiVersion))
  add(path_568683, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568685 = vmInstanceIDs
  result = call_568682.call(path_568683, query_568684, nil, nil, body_568685)

var virtualMachineScaleSetsPowerOff* = Call_VirtualMachineScaleSetsPowerOff_568673(
    name: "virtualMachineScaleSetsPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/poweroff",
    validator: validate_VirtualMachineScaleSetsPowerOff_568674, base: "",
    url: url_VirtualMachineScaleSetsPowerOff_568675, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsReimage_568686 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsReimage_568688(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/reimage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsReimage_568687(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568689 = path.getOrDefault("vmScaleSetName")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "vmScaleSetName", valid_568689
  var valid_568690 = path.getOrDefault("resourceGroupName")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "resourceGroupName", valid_568690
  var valid_568691 = path.getOrDefault("subscriptionId")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "subscriptionId", valid_568691
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568692 = query.getOrDefault("api-version")
  valid_568692 = validateParameter(valid_568692, JString, required = true,
                                 default = nil)
  if valid_568692 != nil:
    section.add "api-version", valid_568692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568694: Call_VirtualMachineScaleSetsReimage_568686; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set.
  ## 
  let valid = call_568694.validator(path, query, header, formData, body)
  let scheme = call_568694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568694.url(scheme.get, call_568694.host, call_568694.base,
                         call_568694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568694, url, valid)

proc call*(call_568695: Call_VirtualMachineScaleSetsReimage_568686;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsReimage
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568696 = newJObject()
  var query_568697 = newJObject()
  var body_568698 = newJObject()
  add(path_568696, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568696, "resourceGroupName", newJString(resourceGroupName))
  add(query_568697, "api-version", newJString(apiVersion))
  add(path_568696, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568698 = vmInstanceIDs
  result = call_568695.call(path_568696, query_568697, nil, nil, body_568698)

var virtualMachineScaleSetsReimage* = Call_VirtualMachineScaleSetsReimage_568686(
    name: "virtualMachineScaleSetsReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimage",
    validator: validate_VirtualMachineScaleSetsReimage_568687, base: "",
    url: url_VirtualMachineScaleSetsReimage_568688, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsReimageAll_568699 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsReimageAll_568701(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/reimageall")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsReimageAll_568700(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568702 = path.getOrDefault("vmScaleSetName")
  valid_568702 = validateParameter(valid_568702, JString, required = true,
                                 default = nil)
  if valid_568702 != nil:
    section.add "vmScaleSetName", valid_568702
  var valid_568703 = path.getOrDefault("resourceGroupName")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "resourceGroupName", valid_568703
  var valid_568704 = path.getOrDefault("subscriptionId")
  valid_568704 = validateParameter(valid_568704, JString, required = true,
                                 default = nil)
  if valid_568704 != nil:
    section.add "subscriptionId", valid_568704
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568705 = query.getOrDefault("api-version")
  valid_568705 = validateParameter(valid_568705, JString, required = true,
                                 default = nil)
  if valid_568705 != nil:
    section.add "api-version", valid_568705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568707: Call_VirtualMachineScaleSetsReimageAll_568699;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.
  ## 
  let valid = call_568707.validator(path, query, header, formData, body)
  let scheme = call_568707.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568707.url(scheme.get, call_568707.host, call_568707.base,
                         call_568707.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568707, url, valid)

proc call*(call_568708: Call_VirtualMachineScaleSetsReimageAll_568699;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsReimageAll
  ## Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568709 = newJObject()
  var query_568710 = newJObject()
  var body_568711 = newJObject()
  add(path_568709, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568709, "resourceGroupName", newJString(resourceGroupName))
  add(query_568710, "api-version", newJString(apiVersion))
  add(path_568709, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568711 = vmInstanceIDs
  result = call_568708.call(path_568709, query_568710, nil, nil, body_568711)

var virtualMachineScaleSetsReimageAll* = Call_VirtualMachineScaleSetsReimageAll_568699(
    name: "virtualMachineScaleSetsReimageAll", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimageall",
    validator: validate_VirtualMachineScaleSetsReimageAll_568700, base: "",
    url: url_VirtualMachineScaleSetsReimageAll_568701, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsRestart_568712 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsRestart_568714(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsRestart_568713(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restarts one or more virtual machines in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568715 = path.getOrDefault("vmScaleSetName")
  valid_568715 = validateParameter(valid_568715, JString, required = true,
                                 default = nil)
  if valid_568715 != nil:
    section.add "vmScaleSetName", valid_568715
  var valid_568716 = path.getOrDefault("resourceGroupName")
  valid_568716 = validateParameter(valid_568716, JString, required = true,
                                 default = nil)
  if valid_568716 != nil:
    section.add "resourceGroupName", valid_568716
  var valid_568717 = path.getOrDefault("subscriptionId")
  valid_568717 = validateParameter(valid_568717, JString, required = true,
                                 default = nil)
  if valid_568717 != nil:
    section.add "subscriptionId", valid_568717
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568718 = query.getOrDefault("api-version")
  valid_568718 = validateParameter(valid_568718, JString, required = true,
                                 default = nil)
  if valid_568718 != nil:
    section.add "api-version", valid_568718
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568720: Call_VirtualMachineScaleSetsRestart_568712; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts one or more virtual machines in a VM scale set.
  ## 
  let valid = call_568720.validator(path, query, header, formData, body)
  let scheme = call_568720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568720.url(scheme.get, call_568720.host, call_568720.base,
                         call_568720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568720, url, valid)

proc call*(call_568721: Call_VirtualMachineScaleSetsRestart_568712;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsRestart
  ## Restarts one or more virtual machines in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568722 = newJObject()
  var query_568723 = newJObject()
  var body_568724 = newJObject()
  add(path_568722, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568722, "resourceGroupName", newJString(resourceGroupName))
  add(query_568723, "api-version", newJString(apiVersion))
  add(path_568722, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568724 = vmInstanceIDs
  result = call_568721.call(path_568722, query_568723, nil, nil, body_568724)

var virtualMachineScaleSetsRestart* = Call_VirtualMachineScaleSetsRestart_568712(
    name: "virtualMachineScaleSetsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/restart",
    validator: validate_VirtualMachineScaleSetsRestart_568713, base: "",
    url: url_VirtualMachineScaleSetsRestart_568714, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesCancel_568725 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetRollingUpgradesCancel_568727(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/rollingUpgrades/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetRollingUpgradesCancel_568726(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the current virtual machine scale set rolling upgrade.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568728 = path.getOrDefault("vmScaleSetName")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "vmScaleSetName", valid_568728
  var valid_568729 = path.getOrDefault("resourceGroupName")
  valid_568729 = validateParameter(valid_568729, JString, required = true,
                                 default = nil)
  if valid_568729 != nil:
    section.add "resourceGroupName", valid_568729
  var valid_568730 = path.getOrDefault("subscriptionId")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "subscriptionId", valid_568730
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568731 = query.getOrDefault("api-version")
  valid_568731 = validateParameter(valid_568731, JString, required = true,
                                 default = nil)
  if valid_568731 != nil:
    section.add "api-version", valid_568731
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568732: Call_VirtualMachineScaleSetRollingUpgradesCancel_568725;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the current virtual machine scale set rolling upgrade.
  ## 
  let valid = call_568732.validator(path, query, header, formData, body)
  let scheme = call_568732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568732.url(scheme.get, call_568732.host, call_568732.base,
                         call_568732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568732, url, valid)

proc call*(call_568733: Call_VirtualMachineScaleSetRollingUpgradesCancel_568725;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetRollingUpgradesCancel
  ## Cancels the current virtual machine scale set rolling upgrade.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568734 = newJObject()
  var query_568735 = newJObject()
  add(path_568734, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568734, "resourceGroupName", newJString(resourceGroupName))
  add(query_568735, "api-version", newJString(apiVersion))
  add(path_568734, "subscriptionId", newJString(subscriptionId))
  result = call_568733.call(path_568734, query_568735, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesCancel* = Call_VirtualMachineScaleSetRollingUpgradesCancel_568725(
    name: "virtualMachineScaleSetRollingUpgradesCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/cancel",
    validator: validate_VirtualMachineScaleSetRollingUpgradesCancel_568726,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesCancel_568727,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesGetLatest_568736 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetRollingUpgradesGetLatest_568738(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/rollingUpgrades/latest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetRollingUpgradesGetLatest_568737(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the status of the latest virtual machine scale set rolling upgrade.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568739 = path.getOrDefault("vmScaleSetName")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = nil)
  if valid_568739 != nil:
    section.add "vmScaleSetName", valid_568739
  var valid_568740 = path.getOrDefault("resourceGroupName")
  valid_568740 = validateParameter(valid_568740, JString, required = true,
                                 default = nil)
  if valid_568740 != nil:
    section.add "resourceGroupName", valid_568740
  var valid_568741 = path.getOrDefault("subscriptionId")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "subscriptionId", valid_568741
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568742 = query.getOrDefault("api-version")
  valid_568742 = validateParameter(valid_568742, JString, required = true,
                                 default = nil)
  if valid_568742 != nil:
    section.add "api-version", valid_568742
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568743: Call_VirtualMachineScaleSetRollingUpgradesGetLatest_568736;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of the latest virtual machine scale set rolling upgrade.
  ## 
  let valid = call_568743.validator(path, query, header, formData, body)
  let scheme = call_568743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568743.url(scheme.get, call_568743.host, call_568743.base,
                         call_568743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568743, url, valid)

proc call*(call_568744: Call_VirtualMachineScaleSetRollingUpgradesGetLatest_568736;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetRollingUpgradesGetLatest
  ## Gets the status of the latest virtual machine scale set rolling upgrade.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568745 = newJObject()
  var query_568746 = newJObject()
  add(path_568745, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568745, "resourceGroupName", newJString(resourceGroupName))
  add(query_568746, "api-version", newJString(apiVersion))
  add(path_568745, "subscriptionId", newJString(subscriptionId))
  result = call_568744.call(path_568745, query_568746, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesGetLatest* = Call_VirtualMachineScaleSetRollingUpgradesGetLatest_568736(
    name: "virtualMachineScaleSetRollingUpgradesGetLatest",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/latest",
    validator: validate_VirtualMachineScaleSetRollingUpgradesGetLatest_568737,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesGetLatest_568738,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsListSkus_568747 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsListSkus_568749(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsListSkus_568748(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568750 = path.getOrDefault("vmScaleSetName")
  valid_568750 = validateParameter(valid_568750, JString, required = true,
                                 default = nil)
  if valid_568750 != nil:
    section.add "vmScaleSetName", valid_568750
  var valid_568751 = path.getOrDefault("resourceGroupName")
  valid_568751 = validateParameter(valid_568751, JString, required = true,
                                 default = nil)
  if valid_568751 != nil:
    section.add "resourceGroupName", valid_568751
  var valid_568752 = path.getOrDefault("subscriptionId")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "subscriptionId", valid_568752
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568753 = query.getOrDefault("api-version")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "api-version", valid_568753
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568754: Call_VirtualMachineScaleSetsListSkus_568747;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.
  ## 
  let valid = call_568754.validator(path, query, header, formData, body)
  let scheme = call_568754.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568754.url(scheme.get, call_568754.host, call_568754.base,
                         call_568754.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568754, url, valid)

proc call*(call_568755: Call_VirtualMachineScaleSetsListSkus_568747;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsListSkus
  ## Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568756 = newJObject()
  var query_568757 = newJObject()
  add(path_568756, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568756, "resourceGroupName", newJString(resourceGroupName))
  add(query_568757, "api-version", newJString(apiVersion))
  add(path_568756, "subscriptionId", newJString(subscriptionId))
  result = call_568755.call(path_568756, query_568757, nil, nil, nil)

var virtualMachineScaleSetsListSkus* = Call_VirtualMachineScaleSetsListSkus_568747(
    name: "virtualMachineScaleSetsListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/skus",
    validator: validate_VirtualMachineScaleSetsListSkus_568748, base: "",
    url: url_VirtualMachineScaleSetsListSkus_568749, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsStart_568758 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsStart_568760(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsStart_568759(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts one or more virtual machines in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568761 = path.getOrDefault("vmScaleSetName")
  valid_568761 = validateParameter(valid_568761, JString, required = true,
                                 default = nil)
  if valid_568761 != nil:
    section.add "vmScaleSetName", valid_568761
  var valid_568762 = path.getOrDefault("resourceGroupName")
  valid_568762 = validateParameter(valid_568762, JString, required = true,
                                 default = nil)
  if valid_568762 != nil:
    section.add "resourceGroupName", valid_568762
  var valid_568763 = path.getOrDefault("subscriptionId")
  valid_568763 = validateParameter(valid_568763, JString, required = true,
                                 default = nil)
  if valid_568763 != nil:
    section.add "subscriptionId", valid_568763
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568764 = query.getOrDefault("api-version")
  valid_568764 = validateParameter(valid_568764, JString, required = true,
                                 default = nil)
  if valid_568764 != nil:
    section.add "api-version", valid_568764
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568766: Call_VirtualMachineScaleSetsStart_568758; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts one or more virtual machines in a VM scale set.
  ## 
  let valid = call_568766.validator(path, query, header, formData, body)
  let scheme = call_568766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568766.url(scheme.get, call_568766.host, call_568766.base,
                         call_568766.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568766, url, valid)

proc call*(call_568767: Call_VirtualMachineScaleSetsStart_568758;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsStart
  ## Starts one or more virtual machines in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568768 = newJObject()
  var query_568769 = newJObject()
  var body_568770 = newJObject()
  add(path_568768, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568768, "resourceGroupName", newJString(resourceGroupName))
  add(query_568769, "api-version", newJString(apiVersion))
  add(path_568768, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568770 = vmInstanceIDs
  result = call_568767.call(path_568768, query_568769, nil, nil, body_568770)

var virtualMachineScaleSetsStart* = Call_VirtualMachineScaleSetsStart_568758(
    name: "virtualMachineScaleSetsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/start",
    validator: validate_VirtualMachineScaleSetsStart_568759, base: "",
    url: url_VirtualMachineScaleSetsStart_568760, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsGet_568771 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsGet_568773(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsGet_568772(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a virtual machine from a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568774 = path.getOrDefault("vmScaleSetName")
  valid_568774 = validateParameter(valid_568774, JString, required = true,
                                 default = nil)
  if valid_568774 != nil:
    section.add "vmScaleSetName", valid_568774
  var valid_568775 = path.getOrDefault("resourceGroupName")
  valid_568775 = validateParameter(valid_568775, JString, required = true,
                                 default = nil)
  if valid_568775 != nil:
    section.add "resourceGroupName", valid_568775
  var valid_568776 = path.getOrDefault("subscriptionId")
  valid_568776 = validateParameter(valid_568776, JString, required = true,
                                 default = nil)
  if valid_568776 != nil:
    section.add "subscriptionId", valid_568776
  var valid_568777 = path.getOrDefault("instanceId")
  valid_568777 = validateParameter(valid_568777, JString, required = true,
                                 default = nil)
  if valid_568777 != nil:
    section.add "instanceId", valid_568777
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568778 = query.getOrDefault("api-version")
  valid_568778 = validateParameter(valid_568778, JString, required = true,
                                 default = nil)
  if valid_568778 != nil:
    section.add "api-version", valid_568778
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568779: Call_VirtualMachineScaleSetVMsGet_568771; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual machine from a VM scale set.
  ## 
  let valid = call_568779.validator(path, query, header, formData, body)
  let scheme = call_568779.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568779.url(scheme.get, call_568779.host, call_568779.base,
                         call_568779.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568779, url, valid)

proc call*(call_568780: Call_VirtualMachineScaleSetVMsGet_568771;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsGet
  ## Gets a virtual machine from a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_568781 = newJObject()
  var query_568782 = newJObject()
  add(path_568781, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568781, "resourceGroupName", newJString(resourceGroupName))
  add(query_568782, "api-version", newJString(apiVersion))
  add(path_568781, "subscriptionId", newJString(subscriptionId))
  add(path_568781, "instanceId", newJString(instanceId))
  result = call_568780.call(path_568781, query_568782, nil, nil, nil)

var virtualMachineScaleSetVMsGet* = Call_VirtualMachineScaleSetVMsGet_568771(
    name: "virtualMachineScaleSetVMsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsGet_568772, base: "",
    url: url_VirtualMachineScaleSetVMsGet_568773, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsDelete_568783 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsDelete_568785(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsDelete_568784(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a virtual machine from a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568786 = path.getOrDefault("vmScaleSetName")
  valid_568786 = validateParameter(valid_568786, JString, required = true,
                                 default = nil)
  if valid_568786 != nil:
    section.add "vmScaleSetName", valid_568786
  var valid_568787 = path.getOrDefault("resourceGroupName")
  valid_568787 = validateParameter(valid_568787, JString, required = true,
                                 default = nil)
  if valid_568787 != nil:
    section.add "resourceGroupName", valid_568787
  var valid_568788 = path.getOrDefault("subscriptionId")
  valid_568788 = validateParameter(valid_568788, JString, required = true,
                                 default = nil)
  if valid_568788 != nil:
    section.add "subscriptionId", valid_568788
  var valid_568789 = path.getOrDefault("instanceId")
  valid_568789 = validateParameter(valid_568789, JString, required = true,
                                 default = nil)
  if valid_568789 != nil:
    section.add "instanceId", valid_568789
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568790 = query.getOrDefault("api-version")
  valid_568790 = validateParameter(valid_568790, JString, required = true,
                                 default = nil)
  if valid_568790 != nil:
    section.add "api-version", valid_568790
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568791: Call_VirtualMachineScaleSetVMsDelete_568783;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a virtual machine from a VM scale set.
  ## 
  let valid = call_568791.validator(path, query, header, formData, body)
  let scheme = call_568791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568791.url(scheme.get, call_568791.host, call_568791.base,
                         call_568791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568791, url, valid)

proc call*(call_568792: Call_VirtualMachineScaleSetVMsDelete_568783;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsDelete
  ## Deletes a virtual machine from a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_568793 = newJObject()
  var query_568794 = newJObject()
  add(path_568793, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568793, "resourceGroupName", newJString(resourceGroupName))
  add(query_568794, "api-version", newJString(apiVersion))
  add(path_568793, "subscriptionId", newJString(subscriptionId))
  add(path_568793, "instanceId", newJString(instanceId))
  result = call_568792.call(path_568793, query_568794, nil, nil, nil)

var virtualMachineScaleSetVMsDelete* = Call_VirtualMachineScaleSetVMsDelete_568783(
    name: "virtualMachineScaleSetVMsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsDelete_568784, base: "",
    url: url_VirtualMachineScaleSetVMsDelete_568785, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsDeallocate_568795 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsDeallocate_568797(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/deallocate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsDeallocate_568796(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deallocates a specific virtual machine in a VM scale set. Shuts down the virtual machine and releases the compute resources it uses. You are not billed for the compute resources of this virtual machine once it is deallocated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568798 = path.getOrDefault("vmScaleSetName")
  valid_568798 = validateParameter(valid_568798, JString, required = true,
                                 default = nil)
  if valid_568798 != nil:
    section.add "vmScaleSetName", valid_568798
  var valid_568799 = path.getOrDefault("resourceGroupName")
  valid_568799 = validateParameter(valid_568799, JString, required = true,
                                 default = nil)
  if valid_568799 != nil:
    section.add "resourceGroupName", valid_568799
  var valid_568800 = path.getOrDefault("subscriptionId")
  valid_568800 = validateParameter(valid_568800, JString, required = true,
                                 default = nil)
  if valid_568800 != nil:
    section.add "subscriptionId", valid_568800
  var valid_568801 = path.getOrDefault("instanceId")
  valid_568801 = validateParameter(valid_568801, JString, required = true,
                                 default = nil)
  if valid_568801 != nil:
    section.add "instanceId", valid_568801
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568802 = query.getOrDefault("api-version")
  valid_568802 = validateParameter(valid_568802, JString, required = true,
                                 default = nil)
  if valid_568802 != nil:
    section.add "api-version", valid_568802
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568803: Call_VirtualMachineScaleSetVMsDeallocate_568795;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deallocates a specific virtual machine in a VM scale set. Shuts down the virtual machine and releases the compute resources it uses. You are not billed for the compute resources of this virtual machine once it is deallocated.
  ## 
  let valid = call_568803.validator(path, query, header, formData, body)
  let scheme = call_568803.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568803.url(scheme.get, call_568803.host, call_568803.base,
                         call_568803.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568803, url, valid)

proc call*(call_568804: Call_VirtualMachineScaleSetVMsDeallocate_568795;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsDeallocate
  ## Deallocates a specific virtual machine in a VM scale set. Shuts down the virtual machine and releases the compute resources it uses. You are not billed for the compute resources of this virtual machine once it is deallocated.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_568805 = newJObject()
  var query_568806 = newJObject()
  add(path_568805, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568805, "resourceGroupName", newJString(resourceGroupName))
  add(query_568806, "api-version", newJString(apiVersion))
  add(path_568805, "subscriptionId", newJString(subscriptionId))
  add(path_568805, "instanceId", newJString(instanceId))
  result = call_568804.call(path_568805, query_568806, nil, nil, nil)

var virtualMachineScaleSetVMsDeallocate* = Call_VirtualMachineScaleSetVMsDeallocate_568795(
    name: "virtualMachineScaleSetVMsDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/deallocate",
    validator: validate_VirtualMachineScaleSetVMsDeallocate_568796, base: "",
    url: url_VirtualMachineScaleSetVMsDeallocate_568797, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsGetInstanceView_568807 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsGetInstanceView_568809(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/instanceView")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsGetInstanceView_568808(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of a virtual machine from a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568810 = path.getOrDefault("vmScaleSetName")
  valid_568810 = validateParameter(valid_568810, JString, required = true,
                                 default = nil)
  if valid_568810 != nil:
    section.add "vmScaleSetName", valid_568810
  var valid_568811 = path.getOrDefault("resourceGroupName")
  valid_568811 = validateParameter(valid_568811, JString, required = true,
                                 default = nil)
  if valid_568811 != nil:
    section.add "resourceGroupName", valid_568811
  var valid_568812 = path.getOrDefault("subscriptionId")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = nil)
  if valid_568812 != nil:
    section.add "subscriptionId", valid_568812
  var valid_568813 = path.getOrDefault("instanceId")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "instanceId", valid_568813
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568814 = query.getOrDefault("api-version")
  valid_568814 = validateParameter(valid_568814, JString, required = true,
                                 default = nil)
  if valid_568814 != nil:
    section.add "api-version", valid_568814
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568815: Call_VirtualMachineScaleSetVMsGetInstanceView_568807;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a virtual machine from a VM scale set.
  ## 
  let valid = call_568815.validator(path, query, header, formData, body)
  let scheme = call_568815.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568815.url(scheme.get, call_568815.host, call_568815.base,
                         call_568815.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568815, url, valid)

proc call*(call_568816: Call_VirtualMachineScaleSetVMsGetInstanceView_568807;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsGetInstanceView
  ## Gets the status of a virtual machine from a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_568817 = newJObject()
  var query_568818 = newJObject()
  add(path_568817, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568817, "resourceGroupName", newJString(resourceGroupName))
  add(query_568818, "api-version", newJString(apiVersion))
  add(path_568817, "subscriptionId", newJString(subscriptionId))
  add(path_568817, "instanceId", newJString(instanceId))
  result = call_568816.call(path_568817, query_568818, nil, nil, nil)

var virtualMachineScaleSetVMsGetInstanceView* = Call_VirtualMachineScaleSetVMsGetInstanceView_568807(
    name: "virtualMachineScaleSetVMsGetInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/instanceView",
    validator: validate_VirtualMachineScaleSetVMsGetInstanceView_568808, base: "",
    url: url_VirtualMachineScaleSetVMsGetInstanceView_568809,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsPowerOff_568819 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsPowerOff_568821(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/poweroff")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsPowerOff_568820(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568822 = path.getOrDefault("vmScaleSetName")
  valid_568822 = validateParameter(valid_568822, JString, required = true,
                                 default = nil)
  if valid_568822 != nil:
    section.add "vmScaleSetName", valid_568822
  var valid_568823 = path.getOrDefault("resourceGroupName")
  valid_568823 = validateParameter(valid_568823, JString, required = true,
                                 default = nil)
  if valid_568823 != nil:
    section.add "resourceGroupName", valid_568823
  var valid_568824 = path.getOrDefault("subscriptionId")
  valid_568824 = validateParameter(valid_568824, JString, required = true,
                                 default = nil)
  if valid_568824 != nil:
    section.add "subscriptionId", valid_568824
  var valid_568825 = path.getOrDefault("instanceId")
  valid_568825 = validateParameter(valid_568825, JString, required = true,
                                 default = nil)
  if valid_568825 != nil:
    section.add "instanceId", valid_568825
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568826 = query.getOrDefault("api-version")
  valid_568826 = validateParameter(valid_568826, JString, required = true,
                                 default = nil)
  if valid_568826 != nil:
    section.add "api-version", valid_568826
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568827: Call_VirtualMachineScaleSetVMsPowerOff_568819;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  let valid = call_568827.validator(path, query, header, formData, body)
  let scheme = call_568827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568827.url(scheme.get, call_568827.host, call_568827.base,
                         call_568827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568827, url, valid)

proc call*(call_568828: Call_VirtualMachineScaleSetVMsPowerOff_568819;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsPowerOff
  ## Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_568829 = newJObject()
  var query_568830 = newJObject()
  add(path_568829, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568829, "resourceGroupName", newJString(resourceGroupName))
  add(query_568830, "api-version", newJString(apiVersion))
  add(path_568829, "subscriptionId", newJString(subscriptionId))
  add(path_568829, "instanceId", newJString(instanceId))
  result = call_568828.call(path_568829, query_568830, nil, nil, nil)

var virtualMachineScaleSetVMsPowerOff* = Call_VirtualMachineScaleSetVMsPowerOff_568819(
    name: "virtualMachineScaleSetVMsPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/poweroff",
    validator: validate_VirtualMachineScaleSetVMsPowerOff_568820, base: "",
    url: url_VirtualMachineScaleSetVMsPowerOff_568821, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsReimage_568831 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsReimage_568833(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/reimage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsReimage_568832(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reimages (upgrade the operating system) a specific virtual machine in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568834 = path.getOrDefault("vmScaleSetName")
  valid_568834 = validateParameter(valid_568834, JString, required = true,
                                 default = nil)
  if valid_568834 != nil:
    section.add "vmScaleSetName", valid_568834
  var valid_568835 = path.getOrDefault("resourceGroupName")
  valid_568835 = validateParameter(valid_568835, JString, required = true,
                                 default = nil)
  if valid_568835 != nil:
    section.add "resourceGroupName", valid_568835
  var valid_568836 = path.getOrDefault("subscriptionId")
  valid_568836 = validateParameter(valid_568836, JString, required = true,
                                 default = nil)
  if valid_568836 != nil:
    section.add "subscriptionId", valid_568836
  var valid_568837 = path.getOrDefault("instanceId")
  valid_568837 = validateParameter(valid_568837, JString, required = true,
                                 default = nil)
  if valid_568837 != nil:
    section.add "instanceId", valid_568837
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568838 = query.getOrDefault("api-version")
  valid_568838 = validateParameter(valid_568838, JString, required = true,
                                 default = nil)
  if valid_568838 != nil:
    section.add "api-version", valid_568838
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568839: Call_VirtualMachineScaleSetVMsReimage_568831;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reimages (upgrade the operating system) a specific virtual machine in a VM scale set.
  ## 
  let valid = call_568839.validator(path, query, header, formData, body)
  let scheme = call_568839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568839.url(scheme.get, call_568839.host, call_568839.base,
                         call_568839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568839, url, valid)

proc call*(call_568840: Call_VirtualMachineScaleSetVMsReimage_568831;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsReimage
  ## Reimages (upgrade the operating system) a specific virtual machine in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_568841 = newJObject()
  var query_568842 = newJObject()
  add(path_568841, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568841, "resourceGroupName", newJString(resourceGroupName))
  add(query_568842, "api-version", newJString(apiVersion))
  add(path_568841, "subscriptionId", newJString(subscriptionId))
  add(path_568841, "instanceId", newJString(instanceId))
  result = call_568840.call(path_568841, query_568842, nil, nil, nil)

var virtualMachineScaleSetVMsReimage* = Call_VirtualMachineScaleSetVMsReimage_568831(
    name: "virtualMachineScaleSetVMsReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/reimage",
    validator: validate_VirtualMachineScaleSetVMsReimage_568832, base: "",
    url: url_VirtualMachineScaleSetVMsReimage_568833, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsReimageAll_568843 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsReimageAll_568845(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/reimageall")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsReimageAll_568844(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows you to re-image all the disks ( including data disks ) in the a VM scale set instance. This operation is only supported for managed disks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568846 = path.getOrDefault("vmScaleSetName")
  valid_568846 = validateParameter(valid_568846, JString, required = true,
                                 default = nil)
  if valid_568846 != nil:
    section.add "vmScaleSetName", valid_568846
  var valid_568847 = path.getOrDefault("resourceGroupName")
  valid_568847 = validateParameter(valid_568847, JString, required = true,
                                 default = nil)
  if valid_568847 != nil:
    section.add "resourceGroupName", valid_568847
  var valid_568848 = path.getOrDefault("subscriptionId")
  valid_568848 = validateParameter(valid_568848, JString, required = true,
                                 default = nil)
  if valid_568848 != nil:
    section.add "subscriptionId", valid_568848
  var valid_568849 = path.getOrDefault("instanceId")
  valid_568849 = validateParameter(valid_568849, JString, required = true,
                                 default = nil)
  if valid_568849 != nil:
    section.add "instanceId", valid_568849
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568850 = query.getOrDefault("api-version")
  valid_568850 = validateParameter(valid_568850, JString, required = true,
                                 default = nil)
  if valid_568850 != nil:
    section.add "api-version", valid_568850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568851: Call_VirtualMachineScaleSetVMsReimageAll_568843;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Allows you to re-image all the disks ( including data disks ) in the a VM scale set instance. This operation is only supported for managed disks.
  ## 
  let valid = call_568851.validator(path, query, header, formData, body)
  let scheme = call_568851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568851.url(scheme.get, call_568851.host, call_568851.base,
                         call_568851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568851, url, valid)

proc call*(call_568852: Call_VirtualMachineScaleSetVMsReimageAll_568843;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsReimageAll
  ## Allows you to re-image all the disks ( including data disks ) in the a VM scale set instance. This operation is only supported for managed disks.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_568853 = newJObject()
  var query_568854 = newJObject()
  add(path_568853, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568853, "resourceGroupName", newJString(resourceGroupName))
  add(query_568854, "api-version", newJString(apiVersion))
  add(path_568853, "subscriptionId", newJString(subscriptionId))
  add(path_568853, "instanceId", newJString(instanceId))
  result = call_568852.call(path_568853, query_568854, nil, nil, nil)

var virtualMachineScaleSetVMsReimageAll* = Call_VirtualMachineScaleSetVMsReimageAll_568843(
    name: "virtualMachineScaleSetVMsReimageAll", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/reimageall",
    validator: validate_VirtualMachineScaleSetVMsReimageAll_568844, base: "",
    url: url_VirtualMachineScaleSetVMsReimageAll_568845, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsRestart_568855 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsRestart_568857(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsRestart_568856(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restarts a virtual machine in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568858 = path.getOrDefault("vmScaleSetName")
  valid_568858 = validateParameter(valid_568858, JString, required = true,
                                 default = nil)
  if valid_568858 != nil:
    section.add "vmScaleSetName", valid_568858
  var valid_568859 = path.getOrDefault("resourceGroupName")
  valid_568859 = validateParameter(valid_568859, JString, required = true,
                                 default = nil)
  if valid_568859 != nil:
    section.add "resourceGroupName", valid_568859
  var valid_568860 = path.getOrDefault("subscriptionId")
  valid_568860 = validateParameter(valid_568860, JString, required = true,
                                 default = nil)
  if valid_568860 != nil:
    section.add "subscriptionId", valid_568860
  var valid_568861 = path.getOrDefault("instanceId")
  valid_568861 = validateParameter(valid_568861, JString, required = true,
                                 default = nil)
  if valid_568861 != nil:
    section.add "instanceId", valid_568861
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568862 = query.getOrDefault("api-version")
  valid_568862 = validateParameter(valid_568862, JString, required = true,
                                 default = nil)
  if valid_568862 != nil:
    section.add "api-version", valid_568862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568863: Call_VirtualMachineScaleSetVMsRestart_568855;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restarts a virtual machine in a VM scale set.
  ## 
  let valid = call_568863.validator(path, query, header, formData, body)
  let scheme = call_568863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568863.url(scheme.get, call_568863.host, call_568863.base,
                         call_568863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568863, url, valid)

proc call*(call_568864: Call_VirtualMachineScaleSetVMsRestart_568855;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsRestart
  ## Restarts a virtual machine in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_568865 = newJObject()
  var query_568866 = newJObject()
  add(path_568865, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568865, "resourceGroupName", newJString(resourceGroupName))
  add(query_568866, "api-version", newJString(apiVersion))
  add(path_568865, "subscriptionId", newJString(subscriptionId))
  add(path_568865, "instanceId", newJString(instanceId))
  result = call_568864.call(path_568865, query_568866, nil, nil, nil)

var virtualMachineScaleSetVMsRestart* = Call_VirtualMachineScaleSetVMsRestart_568855(
    name: "virtualMachineScaleSetVMsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/restart",
    validator: validate_VirtualMachineScaleSetVMsRestart_568856, base: "",
    url: url_VirtualMachineScaleSetVMsRestart_568857, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsStart_568867 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsStart_568869(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsStart_568868(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a virtual machine in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568870 = path.getOrDefault("vmScaleSetName")
  valid_568870 = validateParameter(valid_568870, JString, required = true,
                                 default = nil)
  if valid_568870 != nil:
    section.add "vmScaleSetName", valid_568870
  var valid_568871 = path.getOrDefault("resourceGroupName")
  valid_568871 = validateParameter(valid_568871, JString, required = true,
                                 default = nil)
  if valid_568871 != nil:
    section.add "resourceGroupName", valid_568871
  var valid_568872 = path.getOrDefault("subscriptionId")
  valid_568872 = validateParameter(valid_568872, JString, required = true,
                                 default = nil)
  if valid_568872 != nil:
    section.add "subscriptionId", valid_568872
  var valid_568873 = path.getOrDefault("instanceId")
  valid_568873 = validateParameter(valid_568873, JString, required = true,
                                 default = nil)
  if valid_568873 != nil:
    section.add "instanceId", valid_568873
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568874 = query.getOrDefault("api-version")
  valid_568874 = validateParameter(valid_568874, JString, required = true,
                                 default = nil)
  if valid_568874 != nil:
    section.add "api-version", valid_568874
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568875: Call_VirtualMachineScaleSetVMsStart_568867; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a virtual machine in a VM scale set.
  ## 
  let valid = call_568875.validator(path, query, header, formData, body)
  let scheme = call_568875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568875.url(scheme.get, call_568875.host, call_568875.base,
                         call_568875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568875, url, valid)

proc call*(call_568876: Call_VirtualMachineScaleSetVMsStart_568867;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsStart
  ## Starts a virtual machine in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_568877 = newJObject()
  var query_568878 = newJObject()
  add(path_568877, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568877, "resourceGroupName", newJString(resourceGroupName))
  add(query_568878, "api-version", newJString(apiVersion))
  add(path_568877, "subscriptionId", newJString(subscriptionId))
  add(path_568877, "instanceId", newJString(instanceId))
  result = call_568876.call(path_568877, query_568878, nil, nil, nil)

var virtualMachineScaleSetVMsStart* = Call_VirtualMachineScaleSetVMsStart_568867(
    name: "virtualMachineScaleSetVMsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/start",
    validator: validate_VirtualMachineScaleSetVMsStart_568868, base: "",
    url: url_VirtualMachineScaleSetVMsStart_568869, schemes: {Scheme.Https})
type
  Call_VirtualMachinesList_568879 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesList_568881(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Compute/virtualMachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesList_568880(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568882 = path.getOrDefault("resourceGroupName")
  valid_568882 = validateParameter(valid_568882, JString, required = true,
                                 default = nil)
  if valid_568882 != nil:
    section.add "resourceGroupName", valid_568882
  var valid_568883 = path.getOrDefault("subscriptionId")
  valid_568883 = validateParameter(valid_568883, JString, required = true,
                                 default = nil)
  if valid_568883 != nil:
    section.add "subscriptionId", valid_568883
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568884 = query.getOrDefault("api-version")
  valid_568884 = validateParameter(valid_568884, JString, required = true,
                                 default = nil)
  if valid_568884 != nil:
    section.add "api-version", valid_568884
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568885: Call_VirtualMachinesList_568879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  let valid = call_568885.validator(path, query, header, formData, body)
  let scheme = call_568885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568885.url(scheme.get, call_568885.host, call_568885.base,
                         call_568885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568885, url, valid)

proc call*(call_568886: Call_VirtualMachinesList_568879; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachinesList
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568887 = newJObject()
  var query_568888 = newJObject()
  add(path_568887, "resourceGroupName", newJString(resourceGroupName))
  add(query_568888, "api-version", newJString(apiVersion))
  add(path_568887, "subscriptionId", newJString(subscriptionId))
  result = call_568886.call(path_568887, query_568888, nil, nil, nil)

var virtualMachinesList* = Call_VirtualMachinesList_568879(
    name: "virtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines",
    validator: validate_VirtualMachinesList_568880, base: "",
    url: url_VirtualMachinesList_568881, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCreateOrUpdate_568914 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesCreateOrUpdate_568916(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesCreateOrUpdate_568915(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568917 = path.getOrDefault("resourceGroupName")
  valid_568917 = validateParameter(valid_568917, JString, required = true,
                                 default = nil)
  if valid_568917 != nil:
    section.add "resourceGroupName", valid_568917
  var valid_568918 = path.getOrDefault("subscriptionId")
  valid_568918 = validateParameter(valid_568918, JString, required = true,
                                 default = nil)
  if valid_568918 != nil:
    section.add "subscriptionId", valid_568918
  var valid_568919 = path.getOrDefault("vmName")
  valid_568919 = validateParameter(valid_568919, JString, required = true,
                                 default = nil)
  if valid_568919 != nil:
    section.add "vmName", valid_568919
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568920 = query.getOrDefault("api-version")
  valid_568920 = validateParameter(valid_568920, JString, required = true,
                                 default = nil)
  if valid_568920 != nil:
    section.add "api-version", valid_568920
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Virtual Machine operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568922: Call_VirtualMachinesCreateOrUpdate_568914; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a virtual machine.
  ## 
  let valid = call_568922.validator(path, query, header, formData, body)
  let scheme = call_568922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568922.url(scheme.get, call_568922.host, call_568922.base,
                         call_568922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568922, url, valid)

proc call*(call_568923: Call_VirtualMachinesCreateOrUpdate_568914;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string; parameters: JsonNode): Recallable =
  ## virtualMachinesCreateOrUpdate
  ## The operation to create or update a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Virtual Machine operation.
  var path_568924 = newJObject()
  var query_568925 = newJObject()
  var body_568926 = newJObject()
  add(path_568924, "resourceGroupName", newJString(resourceGroupName))
  add(query_568925, "api-version", newJString(apiVersion))
  add(path_568924, "subscriptionId", newJString(subscriptionId))
  add(path_568924, "vmName", newJString(vmName))
  if parameters != nil:
    body_568926 = parameters
  result = call_568923.call(path_568924, query_568925, nil, nil, body_568926)

var virtualMachinesCreateOrUpdate* = Call_VirtualMachinesCreateOrUpdate_568914(
    name: "virtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesCreateOrUpdate_568915, base: "",
    url: url_VirtualMachinesCreateOrUpdate_568916, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGet_568889 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesGet_568891(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesGet_568890(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves information about the model view or the instance view of a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568892 = path.getOrDefault("resourceGroupName")
  valid_568892 = validateParameter(valid_568892, JString, required = true,
                                 default = nil)
  if valid_568892 != nil:
    section.add "resourceGroupName", valid_568892
  var valid_568893 = path.getOrDefault("subscriptionId")
  valid_568893 = validateParameter(valid_568893, JString, required = true,
                                 default = nil)
  if valid_568893 != nil:
    section.add "subscriptionId", valid_568893
  var valid_568894 = path.getOrDefault("vmName")
  valid_568894 = validateParameter(valid_568894, JString, required = true,
                                 default = nil)
  if valid_568894 != nil:
    section.add "vmName", valid_568894
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568908 = query.getOrDefault("$expand")
  valid_568908 = validateParameter(valid_568908, JString, required = false,
                                 default = newJString("instanceView"))
  if valid_568908 != nil:
    section.add "$expand", valid_568908
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568909 = query.getOrDefault("api-version")
  valid_568909 = validateParameter(valid_568909, JString, required = true,
                                 default = nil)
  if valid_568909 != nil:
    section.add "api-version", valid_568909
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568910: Call_VirtualMachinesGet_568889; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the model view or the instance view of a virtual machine.
  ## 
  let valid = call_568910.validator(path, query, header, formData, body)
  let scheme = call_568910.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568910.url(scheme.get, call_568910.host, call_568910.base,
                         call_568910.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568910, url, valid)

proc call*(call_568911: Call_VirtualMachinesGet_568889; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vmName: string;
          Expand: string = "instanceView"): Recallable =
  ## virtualMachinesGet
  ## Retrieves information about the model view or the instance view of a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_568912 = newJObject()
  var query_568913 = newJObject()
  add(path_568912, "resourceGroupName", newJString(resourceGroupName))
  add(query_568913, "$expand", newJString(Expand))
  add(query_568913, "api-version", newJString(apiVersion))
  add(path_568912, "subscriptionId", newJString(subscriptionId))
  add(path_568912, "vmName", newJString(vmName))
  result = call_568911.call(path_568912, query_568913, nil, nil, nil)

var virtualMachinesGet* = Call_VirtualMachinesGet_568889(
    name: "virtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesGet_568890, base: "",
    url: url_VirtualMachinesGet_568891, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDelete_568927 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesDelete_568929(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesDelete_568928(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568930 = path.getOrDefault("resourceGroupName")
  valid_568930 = validateParameter(valid_568930, JString, required = true,
                                 default = nil)
  if valid_568930 != nil:
    section.add "resourceGroupName", valid_568930
  var valid_568931 = path.getOrDefault("subscriptionId")
  valid_568931 = validateParameter(valid_568931, JString, required = true,
                                 default = nil)
  if valid_568931 != nil:
    section.add "subscriptionId", valid_568931
  var valid_568932 = path.getOrDefault("vmName")
  valid_568932 = validateParameter(valid_568932, JString, required = true,
                                 default = nil)
  if valid_568932 != nil:
    section.add "vmName", valid_568932
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568933 = query.getOrDefault("api-version")
  valid_568933 = validateParameter(valid_568933, JString, required = true,
                                 default = nil)
  if valid_568933 != nil:
    section.add "api-version", valid_568933
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568934: Call_VirtualMachinesDelete_568927; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a virtual machine.
  ## 
  let valid = call_568934.validator(path, query, header, formData, body)
  let scheme = call_568934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568934.url(scheme.get, call_568934.host, call_568934.base,
                         call_568934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568934, url, valid)

proc call*(call_568935: Call_VirtualMachinesDelete_568927;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesDelete
  ## The operation to delete a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_568936 = newJObject()
  var query_568937 = newJObject()
  add(path_568936, "resourceGroupName", newJString(resourceGroupName))
  add(query_568937, "api-version", newJString(apiVersion))
  add(path_568936, "subscriptionId", newJString(subscriptionId))
  add(path_568936, "vmName", newJString(vmName))
  result = call_568935.call(path_568936, query_568937, nil, nil, nil)

var virtualMachinesDelete* = Call_VirtualMachinesDelete_568927(
    name: "virtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesDelete_568928, base: "",
    url: url_VirtualMachinesDelete_568929, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCapture_568938 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesCapture_568940(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/capture")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesCapture_568939(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Captures the VM by copying virtual hard disks of the VM and outputs a template that can be used to create similar VMs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568941 = path.getOrDefault("resourceGroupName")
  valid_568941 = validateParameter(valid_568941, JString, required = true,
                                 default = nil)
  if valid_568941 != nil:
    section.add "resourceGroupName", valid_568941
  var valid_568942 = path.getOrDefault("subscriptionId")
  valid_568942 = validateParameter(valid_568942, JString, required = true,
                                 default = nil)
  if valid_568942 != nil:
    section.add "subscriptionId", valid_568942
  var valid_568943 = path.getOrDefault("vmName")
  valid_568943 = validateParameter(valid_568943, JString, required = true,
                                 default = nil)
  if valid_568943 != nil:
    section.add "vmName", valid_568943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568944 = query.getOrDefault("api-version")
  valid_568944 = validateParameter(valid_568944, JString, required = true,
                                 default = nil)
  if valid_568944 != nil:
    section.add "api-version", valid_568944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Capture Virtual Machine operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568946: Call_VirtualMachinesCapture_568938; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Captures the VM by copying virtual hard disks of the VM and outputs a template that can be used to create similar VMs.
  ## 
  let valid = call_568946.validator(path, query, header, formData, body)
  let scheme = call_568946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568946.url(scheme.get, call_568946.host, call_568946.base,
                         call_568946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568946, url, valid)

proc call*(call_568947: Call_VirtualMachinesCapture_568938;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string; parameters: JsonNode): Recallable =
  ## virtualMachinesCapture
  ## Captures the VM by copying virtual hard disks of the VM and outputs a template that can be used to create similar VMs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Capture Virtual Machine operation.
  var path_568948 = newJObject()
  var query_568949 = newJObject()
  var body_568950 = newJObject()
  add(path_568948, "resourceGroupName", newJString(resourceGroupName))
  add(query_568949, "api-version", newJString(apiVersion))
  add(path_568948, "subscriptionId", newJString(subscriptionId))
  add(path_568948, "vmName", newJString(vmName))
  if parameters != nil:
    body_568950 = parameters
  result = call_568947.call(path_568948, query_568949, nil, nil, body_568950)

var virtualMachinesCapture* = Call_VirtualMachinesCapture_568938(
    name: "virtualMachinesCapture", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/capture",
    validator: validate_VirtualMachinesCapture_568939, base: "",
    url: url_VirtualMachinesCapture_568940, schemes: {Scheme.Https})
type
  Call_VirtualMachinesConvertToManagedDisks_568951 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesConvertToManagedDisks_568953(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/convertToManagedDisks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesConvertToManagedDisks_568952(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Converts virtual machine disks from blob-based to managed disks. Virtual machine must be stop-deallocated before invoking this operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568954 = path.getOrDefault("resourceGroupName")
  valid_568954 = validateParameter(valid_568954, JString, required = true,
                                 default = nil)
  if valid_568954 != nil:
    section.add "resourceGroupName", valid_568954
  var valid_568955 = path.getOrDefault("subscriptionId")
  valid_568955 = validateParameter(valid_568955, JString, required = true,
                                 default = nil)
  if valid_568955 != nil:
    section.add "subscriptionId", valid_568955
  var valid_568956 = path.getOrDefault("vmName")
  valid_568956 = validateParameter(valid_568956, JString, required = true,
                                 default = nil)
  if valid_568956 != nil:
    section.add "vmName", valid_568956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568957 = query.getOrDefault("api-version")
  valid_568957 = validateParameter(valid_568957, JString, required = true,
                                 default = nil)
  if valid_568957 != nil:
    section.add "api-version", valid_568957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568958: Call_VirtualMachinesConvertToManagedDisks_568951;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Converts virtual machine disks from blob-based to managed disks. Virtual machine must be stop-deallocated before invoking this operation.
  ## 
  let valid = call_568958.validator(path, query, header, formData, body)
  let scheme = call_568958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568958.url(scheme.get, call_568958.host, call_568958.base,
                         call_568958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568958, url, valid)

proc call*(call_568959: Call_VirtualMachinesConvertToManagedDisks_568951;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesConvertToManagedDisks
  ## Converts virtual machine disks from blob-based to managed disks. Virtual machine must be stop-deallocated before invoking this operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_568960 = newJObject()
  var query_568961 = newJObject()
  add(path_568960, "resourceGroupName", newJString(resourceGroupName))
  add(query_568961, "api-version", newJString(apiVersion))
  add(path_568960, "subscriptionId", newJString(subscriptionId))
  add(path_568960, "vmName", newJString(vmName))
  result = call_568959.call(path_568960, query_568961, nil, nil, nil)

var virtualMachinesConvertToManagedDisks* = Call_VirtualMachinesConvertToManagedDisks_568951(
    name: "virtualMachinesConvertToManagedDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/convertToManagedDisks",
    validator: validate_VirtualMachinesConvertToManagedDisks_568952, base: "",
    url: url_VirtualMachinesConvertToManagedDisks_568953, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDeallocate_568962 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesDeallocate_568964(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/deallocate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesDeallocate_568963(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shuts down the virtual machine and releases the compute resources. You are not billed for the compute resources that this virtual machine uses.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568965 = path.getOrDefault("resourceGroupName")
  valid_568965 = validateParameter(valid_568965, JString, required = true,
                                 default = nil)
  if valid_568965 != nil:
    section.add "resourceGroupName", valid_568965
  var valid_568966 = path.getOrDefault("subscriptionId")
  valid_568966 = validateParameter(valid_568966, JString, required = true,
                                 default = nil)
  if valid_568966 != nil:
    section.add "subscriptionId", valid_568966
  var valid_568967 = path.getOrDefault("vmName")
  valid_568967 = validateParameter(valid_568967, JString, required = true,
                                 default = nil)
  if valid_568967 != nil:
    section.add "vmName", valid_568967
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568968 = query.getOrDefault("api-version")
  valid_568968 = validateParameter(valid_568968, JString, required = true,
                                 default = nil)
  if valid_568968 != nil:
    section.add "api-version", valid_568968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568969: Call_VirtualMachinesDeallocate_568962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shuts down the virtual machine and releases the compute resources. You are not billed for the compute resources that this virtual machine uses.
  ## 
  let valid = call_568969.validator(path, query, header, formData, body)
  let scheme = call_568969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568969.url(scheme.get, call_568969.host, call_568969.base,
                         call_568969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568969, url, valid)

proc call*(call_568970: Call_VirtualMachinesDeallocate_568962;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesDeallocate
  ## Shuts down the virtual machine and releases the compute resources. You are not billed for the compute resources that this virtual machine uses.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_568971 = newJObject()
  var query_568972 = newJObject()
  add(path_568971, "resourceGroupName", newJString(resourceGroupName))
  add(query_568972, "api-version", newJString(apiVersion))
  add(path_568971, "subscriptionId", newJString(subscriptionId))
  add(path_568971, "vmName", newJString(vmName))
  result = call_568970.call(path_568971, query_568972, nil, nil, nil)

var virtualMachinesDeallocate* = Call_VirtualMachinesDeallocate_568962(
    name: "virtualMachinesDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/deallocate",
    validator: validate_VirtualMachinesDeallocate_568963, base: "",
    url: url_VirtualMachinesDeallocate_568964, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGetExtensions_568973 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesGetExtensions_568975(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/extensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesGetExtensions_568974(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to get all extensions of a Virtual Machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine containing the extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568976 = path.getOrDefault("resourceGroupName")
  valid_568976 = validateParameter(valid_568976, JString, required = true,
                                 default = nil)
  if valid_568976 != nil:
    section.add "resourceGroupName", valid_568976
  var valid_568977 = path.getOrDefault("subscriptionId")
  valid_568977 = validateParameter(valid_568977, JString, required = true,
                                 default = nil)
  if valid_568977 != nil:
    section.add "subscriptionId", valid_568977
  var valid_568978 = path.getOrDefault("vmName")
  valid_568978 = validateParameter(valid_568978, JString, required = true,
                                 default = nil)
  if valid_568978 != nil:
    section.add "vmName", valid_568978
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568979 = query.getOrDefault("$expand")
  valid_568979 = validateParameter(valid_568979, JString, required = false,
                                 default = nil)
  if valid_568979 != nil:
    section.add "$expand", valid_568979
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568980 = query.getOrDefault("api-version")
  valid_568980 = validateParameter(valid_568980, JString, required = true,
                                 default = nil)
  if valid_568980 != nil:
    section.add "api-version", valid_568980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568981: Call_VirtualMachinesGetExtensions_568973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get all extensions of a Virtual Machine.
  ## 
  let valid = call_568981.validator(path, query, header, formData, body)
  let scheme = call_568981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568981.url(scheme.get, call_568981.host, call_568981.base,
                         call_568981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568981, url, valid)

proc call*(call_568982: Call_VirtualMachinesGetExtensions_568973;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string; Expand: string = ""): Recallable =
  ## virtualMachinesGetExtensions
  ## The operation to get all extensions of a Virtual Machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine containing the extension.
  var path_568983 = newJObject()
  var query_568984 = newJObject()
  add(path_568983, "resourceGroupName", newJString(resourceGroupName))
  add(query_568984, "$expand", newJString(Expand))
  add(query_568984, "api-version", newJString(apiVersion))
  add(path_568983, "subscriptionId", newJString(subscriptionId))
  add(path_568983, "vmName", newJString(vmName))
  result = call_568982.call(path_568983, query_568984, nil, nil, nil)

var virtualMachinesGetExtensions* = Call_VirtualMachinesGetExtensions_568973(
    name: "virtualMachinesGetExtensions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions",
    validator: validate_VirtualMachinesGetExtensions_568974, base: "",
    url: url_VirtualMachinesGetExtensions_568975, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsCreateOrUpdate_568998 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsCreateOrUpdate_569000(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  assert "vmExtensionName" in path, "`vmExtensionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/extensions/"),
               (kind: VariableSegment, value: "vmExtensionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineExtensionsCreateOrUpdate_568999(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: JString (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine where the extension should be created or updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569001 = path.getOrDefault("resourceGroupName")
  valid_569001 = validateParameter(valid_569001, JString, required = true,
                                 default = nil)
  if valid_569001 != nil:
    section.add "resourceGroupName", valid_569001
  var valid_569002 = path.getOrDefault("vmExtensionName")
  valid_569002 = validateParameter(valid_569002, JString, required = true,
                                 default = nil)
  if valid_569002 != nil:
    section.add "vmExtensionName", valid_569002
  var valid_569003 = path.getOrDefault("subscriptionId")
  valid_569003 = validateParameter(valid_569003, JString, required = true,
                                 default = nil)
  if valid_569003 != nil:
    section.add "subscriptionId", valid_569003
  var valid_569004 = path.getOrDefault("vmName")
  valid_569004 = validateParameter(valid_569004, JString, required = true,
                                 default = nil)
  if valid_569004 != nil:
    section.add "vmName", valid_569004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569005 = query.getOrDefault("api-version")
  valid_569005 = validateParameter(valid_569005, JString, required = true,
                                 default = nil)
  if valid_569005 != nil:
    section.add "api-version", valid_569005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   extensionParameters: JObject (required)
  ##                      : Parameters supplied to the Create Virtual Machine Extension operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569007: Call_VirtualMachineExtensionsCreateOrUpdate_568998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update the extension.
  ## 
  let valid = call_569007.validator(path, query, header, formData, body)
  let scheme = call_569007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569007.url(scheme.get, call_569007.host, call_569007.base,
                         call_569007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569007, url, valid)

proc call*(call_569008: Call_VirtualMachineExtensionsCreateOrUpdate_568998;
          extensionParameters: JsonNode; resourceGroupName: string;
          apiVersion: string; vmExtensionName: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachineExtensionsCreateOrUpdate
  ## The operation to create or update the extension.
  ##   extensionParameters: JObject (required)
  ##                      : Parameters supplied to the Create Virtual Machine Extension operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmExtensionName: string (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine where the extension should be created or updated.
  var path_569009 = newJObject()
  var query_569010 = newJObject()
  var body_569011 = newJObject()
  if extensionParameters != nil:
    body_569011 = extensionParameters
  add(path_569009, "resourceGroupName", newJString(resourceGroupName))
  add(query_569010, "api-version", newJString(apiVersion))
  add(path_569009, "vmExtensionName", newJString(vmExtensionName))
  add(path_569009, "subscriptionId", newJString(subscriptionId))
  add(path_569009, "vmName", newJString(vmName))
  result = call_569008.call(path_569009, query_569010, nil, nil, body_569011)

var virtualMachineExtensionsCreateOrUpdate* = Call_VirtualMachineExtensionsCreateOrUpdate_568998(
    name: "virtualMachineExtensionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsCreateOrUpdate_568999, base: "",
    url: url_VirtualMachineExtensionsCreateOrUpdate_569000,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsGet_568985 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsGet_568987(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  assert "vmExtensionName" in path, "`vmExtensionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/extensions/"),
               (kind: VariableSegment, value: "vmExtensionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineExtensionsGet_568986(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to get the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: JString (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine containing the extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568988 = path.getOrDefault("resourceGroupName")
  valid_568988 = validateParameter(valid_568988, JString, required = true,
                                 default = nil)
  if valid_568988 != nil:
    section.add "resourceGroupName", valid_568988
  var valid_568989 = path.getOrDefault("vmExtensionName")
  valid_568989 = validateParameter(valid_568989, JString, required = true,
                                 default = nil)
  if valid_568989 != nil:
    section.add "vmExtensionName", valid_568989
  var valid_568990 = path.getOrDefault("subscriptionId")
  valid_568990 = validateParameter(valid_568990, JString, required = true,
                                 default = nil)
  if valid_568990 != nil:
    section.add "subscriptionId", valid_568990
  var valid_568991 = path.getOrDefault("vmName")
  valid_568991 = validateParameter(valid_568991, JString, required = true,
                                 default = nil)
  if valid_568991 != nil:
    section.add "vmName", valid_568991
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568992 = query.getOrDefault("$expand")
  valid_568992 = validateParameter(valid_568992, JString, required = false,
                                 default = nil)
  if valid_568992 != nil:
    section.add "$expand", valid_568992
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568993 = query.getOrDefault("api-version")
  valid_568993 = validateParameter(valid_568993, JString, required = true,
                                 default = nil)
  if valid_568993 != nil:
    section.add "api-version", valid_568993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568994: Call_VirtualMachineExtensionsGet_568985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the extension.
  ## 
  let valid = call_568994.validator(path, query, header, formData, body)
  let scheme = call_568994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568994.url(scheme.get, call_568994.host, call_568994.base,
                         call_568994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568994, url, valid)

proc call*(call_568995: Call_VirtualMachineExtensionsGet_568985;
          resourceGroupName: string; apiVersion: string; vmExtensionName: string;
          subscriptionId: string; vmName: string; Expand: string = ""): Recallable =
  ## virtualMachineExtensionsGet
  ## The operation to get the extension.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmExtensionName: string (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine containing the extension.
  var path_568996 = newJObject()
  var query_568997 = newJObject()
  add(path_568996, "resourceGroupName", newJString(resourceGroupName))
  add(query_568997, "$expand", newJString(Expand))
  add(query_568997, "api-version", newJString(apiVersion))
  add(path_568996, "vmExtensionName", newJString(vmExtensionName))
  add(path_568996, "subscriptionId", newJString(subscriptionId))
  add(path_568996, "vmName", newJString(vmName))
  result = call_568995.call(path_568996, query_568997, nil, nil, nil)

var virtualMachineExtensionsGet* = Call_VirtualMachineExtensionsGet_568985(
    name: "virtualMachineExtensionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsGet_568986, base: "",
    url: url_VirtualMachineExtensionsGet_568987, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsUpdate_569024 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsUpdate_569026(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  assert "vmExtensionName" in path, "`vmExtensionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/extensions/"),
               (kind: VariableSegment, value: "vmExtensionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineExtensionsUpdate_569025(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: JString (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine where the extension should be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569027 = path.getOrDefault("resourceGroupName")
  valid_569027 = validateParameter(valid_569027, JString, required = true,
                                 default = nil)
  if valid_569027 != nil:
    section.add "resourceGroupName", valid_569027
  var valid_569028 = path.getOrDefault("vmExtensionName")
  valid_569028 = validateParameter(valid_569028, JString, required = true,
                                 default = nil)
  if valid_569028 != nil:
    section.add "vmExtensionName", valid_569028
  var valid_569029 = path.getOrDefault("subscriptionId")
  valid_569029 = validateParameter(valid_569029, JString, required = true,
                                 default = nil)
  if valid_569029 != nil:
    section.add "subscriptionId", valid_569029
  var valid_569030 = path.getOrDefault("vmName")
  valid_569030 = validateParameter(valid_569030, JString, required = true,
                                 default = nil)
  if valid_569030 != nil:
    section.add "vmName", valid_569030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569031 = query.getOrDefault("api-version")
  valid_569031 = validateParameter(valid_569031, JString, required = true,
                                 default = nil)
  if valid_569031 != nil:
    section.add "api-version", valid_569031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   extensionParameters: JObject (required)
  ##                      : Parameters supplied to the Update Virtual Machine Extension operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569033: Call_VirtualMachineExtensionsUpdate_569024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update the extension.
  ## 
  let valid = call_569033.validator(path, query, header, formData, body)
  let scheme = call_569033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569033.url(scheme.get, call_569033.host, call_569033.base,
                         call_569033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569033, url, valid)

proc call*(call_569034: Call_VirtualMachineExtensionsUpdate_569024;
          extensionParameters: JsonNode; resourceGroupName: string;
          apiVersion: string; vmExtensionName: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachineExtensionsUpdate
  ## The operation to update the extension.
  ##   extensionParameters: JObject (required)
  ##                      : Parameters supplied to the Update Virtual Machine Extension operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmExtensionName: string (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine where the extension should be updated.
  var path_569035 = newJObject()
  var query_569036 = newJObject()
  var body_569037 = newJObject()
  if extensionParameters != nil:
    body_569037 = extensionParameters
  add(path_569035, "resourceGroupName", newJString(resourceGroupName))
  add(query_569036, "api-version", newJString(apiVersion))
  add(path_569035, "vmExtensionName", newJString(vmExtensionName))
  add(path_569035, "subscriptionId", newJString(subscriptionId))
  add(path_569035, "vmName", newJString(vmName))
  result = call_569034.call(path_569035, query_569036, nil, nil, body_569037)

var virtualMachineExtensionsUpdate* = Call_VirtualMachineExtensionsUpdate_569024(
    name: "virtualMachineExtensionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsUpdate_569025, base: "",
    url: url_VirtualMachineExtensionsUpdate_569026, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsDelete_569012 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsDelete_569014(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  assert "vmExtensionName" in path, "`vmExtensionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/extensions/"),
               (kind: VariableSegment, value: "vmExtensionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineExtensionsDelete_569013(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: JString (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine where the extension should be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569015 = path.getOrDefault("resourceGroupName")
  valid_569015 = validateParameter(valid_569015, JString, required = true,
                                 default = nil)
  if valid_569015 != nil:
    section.add "resourceGroupName", valid_569015
  var valid_569016 = path.getOrDefault("vmExtensionName")
  valid_569016 = validateParameter(valid_569016, JString, required = true,
                                 default = nil)
  if valid_569016 != nil:
    section.add "vmExtensionName", valid_569016
  var valid_569017 = path.getOrDefault("subscriptionId")
  valid_569017 = validateParameter(valid_569017, JString, required = true,
                                 default = nil)
  if valid_569017 != nil:
    section.add "subscriptionId", valid_569017
  var valid_569018 = path.getOrDefault("vmName")
  valid_569018 = validateParameter(valid_569018, JString, required = true,
                                 default = nil)
  if valid_569018 != nil:
    section.add "vmName", valid_569018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569019 = query.getOrDefault("api-version")
  valid_569019 = validateParameter(valid_569019, JString, required = true,
                                 default = nil)
  if valid_569019 != nil:
    section.add "api-version", valid_569019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569020: Call_VirtualMachineExtensionsDelete_569012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete the extension.
  ## 
  let valid = call_569020.validator(path, query, header, formData, body)
  let scheme = call_569020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569020.url(scheme.get, call_569020.host, call_569020.base,
                         call_569020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569020, url, valid)

proc call*(call_569021: Call_VirtualMachineExtensionsDelete_569012;
          resourceGroupName: string; apiVersion: string; vmExtensionName: string;
          subscriptionId: string; vmName: string): Recallable =
  ## virtualMachineExtensionsDelete
  ## The operation to delete the extension.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmExtensionName: string (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine where the extension should be deleted.
  var path_569022 = newJObject()
  var query_569023 = newJObject()
  add(path_569022, "resourceGroupName", newJString(resourceGroupName))
  add(query_569023, "api-version", newJString(apiVersion))
  add(path_569022, "vmExtensionName", newJString(vmExtensionName))
  add(path_569022, "subscriptionId", newJString(subscriptionId))
  add(path_569022, "vmName", newJString(vmName))
  result = call_569021.call(path_569022, query_569023, nil, nil, nil)

var virtualMachineExtensionsDelete* = Call_VirtualMachineExtensionsDelete_569012(
    name: "virtualMachineExtensionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsDelete_569013, base: "",
    url: url_VirtualMachineExtensionsDelete_569014, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGeneralize_569038 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesGeneralize_569040(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/generalize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesGeneralize_569039(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the state of the virtual machine to generalized.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569041 = path.getOrDefault("resourceGroupName")
  valid_569041 = validateParameter(valid_569041, JString, required = true,
                                 default = nil)
  if valid_569041 != nil:
    section.add "resourceGroupName", valid_569041
  var valid_569042 = path.getOrDefault("subscriptionId")
  valid_569042 = validateParameter(valid_569042, JString, required = true,
                                 default = nil)
  if valid_569042 != nil:
    section.add "subscriptionId", valid_569042
  var valid_569043 = path.getOrDefault("vmName")
  valid_569043 = validateParameter(valid_569043, JString, required = true,
                                 default = nil)
  if valid_569043 != nil:
    section.add "vmName", valid_569043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569044 = query.getOrDefault("api-version")
  valid_569044 = validateParameter(valid_569044, JString, required = true,
                                 default = nil)
  if valid_569044 != nil:
    section.add "api-version", valid_569044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569045: Call_VirtualMachinesGeneralize_569038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of the virtual machine to generalized.
  ## 
  let valid = call_569045.validator(path, query, header, formData, body)
  let scheme = call_569045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569045.url(scheme.get, call_569045.host, call_569045.base,
                         call_569045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569045, url, valid)

proc call*(call_569046: Call_VirtualMachinesGeneralize_569038;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesGeneralize
  ## Sets the state of the virtual machine to generalized.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569047 = newJObject()
  var query_569048 = newJObject()
  add(path_569047, "resourceGroupName", newJString(resourceGroupName))
  add(query_569048, "api-version", newJString(apiVersion))
  add(path_569047, "subscriptionId", newJString(subscriptionId))
  add(path_569047, "vmName", newJString(vmName))
  result = call_569046.call(path_569047, query_569048, nil, nil, nil)

var virtualMachinesGeneralize* = Call_VirtualMachinesGeneralize_569038(
    name: "virtualMachinesGeneralize", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/generalize",
    validator: validate_VirtualMachinesGeneralize_569039, base: "",
    url: url_VirtualMachinesGeneralize_569040, schemes: {Scheme.Https})
type
  Call_VirtualMachinesInstanceView_569049 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesInstanceView_569051(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/instanceView")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesInstanceView_569050(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves information about the run-time state of a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569052 = path.getOrDefault("resourceGroupName")
  valid_569052 = validateParameter(valid_569052, JString, required = true,
                                 default = nil)
  if valid_569052 != nil:
    section.add "resourceGroupName", valid_569052
  var valid_569053 = path.getOrDefault("subscriptionId")
  valid_569053 = validateParameter(valid_569053, JString, required = true,
                                 default = nil)
  if valid_569053 != nil:
    section.add "subscriptionId", valid_569053
  var valid_569054 = path.getOrDefault("vmName")
  valid_569054 = validateParameter(valid_569054, JString, required = true,
                                 default = nil)
  if valid_569054 != nil:
    section.add "vmName", valid_569054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569055 = query.getOrDefault("api-version")
  valid_569055 = validateParameter(valid_569055, JString, required = true,
                                 default = nil)
  if valid_569055 != nil:
    section.add "api-version", valid_569055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569056: Call_VirtualMachinesInstanceView_569049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the run-time state of a virtual machine.
  ## 
  let valid = call_569056.validator(path, query, header, formData, body)
  let scheme = call_569056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569056.url(scheme.get, call_569056.host, call_569056.base,
                         call_569056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569056, url, valid)

proc call*(call_569057: Call_VirtualMachinesInstanceView_569049;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesInstanceView
  ## Retrieves information about the run-time state of a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569058 = newJObject()
  var query_569059 = newJObject()
  add(path_569058, "resourceGroupName", newJString(resourceGroupName))
  add(query_569059, "api-version", newJString(apiVersion))
  add(path_569058, "subscriptionId", newJString(subscriptionId))
  add(path_569058, "vmName", newJString(vmName))
  result = call_569057.call(path_569058, query_569059, nil, nil, nil)

var virtualMachinesInstanceView* = Call_VirtualMachinesInstanceView_569049(
    name: "virtualMachinesInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/instanceView",
    validator: validate_VirtualMachinesInstanceView_569050, base: "",
    url: url_VirtualMachinesInstanceView_569051, schemes: {Scheme.Https})
type
  Call_VirtualMachinesPerformMaintenance_569060 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesPerformMaintenance_569062(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/performMaintenance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesPerformMaintenance_569061(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to perform maintenance on a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569063 = path.getOrDefault("resourceGroupName")
  valid_569063 = validateParameter(valid_569063, JString, required = true,
                                 default = nil)
  if valid_569063 != nil:
    section.add "resourceGroupName", valid_569063
  var valid_569064 = path.getOrDefault("subscriptionId")
  valid_569064 = validateParameter(valid_569064, JString, required = true,
                                 default = nil)
  if valid_569064 != nil:
    section.add "subscriptionId", valid_569064
  var valid_569065 = path.getOrDefault("vmName")
  valid_569065 = validateParameter(valid_569065, JString, required = true,
                                 default = nil)
  if valid_569065 != nil:
    section.add "vmName", valid_569065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569066 = query.getOrDefault("api-version")
  valid_569066 = validateParameter(valid_569066, JString, required = true,
                                 default = nil)
  if valid_569066 != nil:
    section.add "api-version", valid_569066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569067: Call_VirtualMachinesPerformMaintenance_569060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to perform maintenance on a virtual machine.
  ## 
  let valid = call_569067.validator(path, query, header, formData, body)
  let scheme = call_569067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569067.url(scheme.get, call_569067.host, call_569067.base,
                         call_569067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569067, url, valid)

proc call*(call_569068: Call_VirtualMachinesPerformMaintenance_569060;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesPerformMaintenance
  ## The operation to perform maintenance on a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569069 = newJObject()
  var query_569070 = newJObject()
  add(path_569069, "resourceGroupName", newJString(resourceGroupName))
  add(query_569070, "api-version", newJString(apiVersion))
  add(path_569069, "subscriptionId", newJString(subscriptionId))
  add(path_569069, "vmName", newJString(vmName))
  result = call_569068.call(path_569069, query_569070, nil, nil, nil)

var virtualMachinesPerformMaintenance* = Call_VirtualMachinesPerformMaintenance_569060(
    name: "virtualMachinesPerformMaintenance", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/performMaintenance",
    validator: validate_VirtualMachinesPerformMaintenance_569061, base: "",
    url: url_VirtualMachinesPerformMaintenance_569062, schemes: {Scheme.Https})
type
  Call_VirtualMachinesPowerOff_569071 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesPowerOff_569073(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/powerOff")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesPowerOff_569072(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569074 = path.getOrDefault("resourceGroupName")
  valid_569074 = validateParameter(valid_569074, JString, required = true,
                                 default = nil)
  if valid_569074 != nil:
    section.add "resourceGroupName", valid_569074
  var valid_569075 = path.getOrDefault("subscriptionId")
  valid_569075 = validateParameter(valid_569075, JString, required = true,
                                 default = nil)
  if valid_569075 != nil:
    section.add "subscriptionId", valid_569075
  var valid_569076 = path.getOrDefault("vmName")
  valid_569076 = validateParameter(valid_569076, JString, required = true,
                                 default = nil)
  if valid_569076 != nil:
    section.add "vmName", valid_569076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569077 = query.getOrDefault("api-version")
  valid_569077 = validateParameter(valid_569077, JString, required = true,
                                 default = nil)
  if valid_569077 != nil:
    section.add "api-version", valid_569077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569078: Call_VirtualMachinesPowerOff_569071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
  ## 
  let valid = call_569078.validator(path, query, header, formData, body)
  let scheme = call_569078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569078.url(scheme.get, call_569078.host, call_569078.base,
                         call_569078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569078, url, valid)

proc call*(call_569079: Call_VirtualMachinesPowerOff_569071;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesPowerOff
  ## The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569080 = newJObject()
  var query_569081 = newJObject()
  add(path_569080, "resourceGroupName", newJString(resourceGroupName))
  add(query_569081, "api-version", newJString(apiVersion))
  add(path_569080, "subscriptionId", newJString(subscriptionId))
  add(path_569080, "vmName", newJString(vmName))
  result = call_569079.call(path_569080, query_569081, nil, nil, nil)

var virtualMachinesPowerOff* = Call_VirtualMachinesPowerOff_569071(
    name: "virtualMachinesPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/powerOff",
    validator: validate_VirtualMachinesPowerOff_569072, base: "",
    url: url_VirtualMachinesPowerOff_569073, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRedeploy_569082 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesRedeploy_569084(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/redeploy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesRedeploy_569083(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shuts down the virtual machine, moves it to a new node, and powers it back on.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569085 = path.getOrDefault("resourceGroupName")
  valid_569085 = validateParameter(valid_569085, JString, required = true,
                                 default = nil)
  if valid_569085 != nil:
    section.add "resourceGroupName", valid_569085
  var valid_569086 = path.getOrDefault("subscriptionId")
  valid_569086 = validateParameter(valid_569086, JString, required = true,
                                 default = nil)
  if valid_569086 != nil:
    section.add "subscriptionId", valid_569086
  var valid_569087 = path.getOrDefault("vmName")
  valid_569087 = validateParameter(valid_569087, JString, required = true,
                                 default = nil)
  if valid_569087 != nil:
    section.add "vmName", valid_569087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569088 = query.getOrDefault("api-version")
  valid_569088 = validateParameter(valid_569088, JString, required = true,
                                 default = nil)
  if valid_569088 != nil:
    section.add "api-version", valid_569088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569089: Call_VirtualMachinesRedeploy_569082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shuts down the virtual machine, moves it to a new node, and powers it back on.
  ## 
  let valid = call_569089.validator(path, query, header, formData, body)
  let scheme = call_569089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569089.url(scheme.get, call_569089.host, call_569089.base,
                         call_569089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569089, url, valid)

proc call*(call_569090: Call_VirtualMachinesRedeploy_569082;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesRedeploy
  ## Shuts down the virtual machine, moves it to a new node, and powers it back on.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569091 = newJObject()
  var query_569092 = newJObject()
  add(path_569091, "resourceGroupName", newJString(resourceGroupName))
  add(query_569092, "api-version", newJString(apiVersion))
  add(path_569091, "subscriptionId", newJString(subscriptionId))
  add(path_569091, "vmName", newJString(vmName))
  result = call_569090.call(path_569091, query_569092, nil, nil, nil)

var virtualMachinesRedeploy* = Call_VirtualMachinesRedeploy_569082(
    name: "virtualMachinesRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/redeploy",
    validator: validate_VirtualMachinesRedeploy_569083, base: "",
    url: url_VirtualMachinesRedeploy_569084, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRestart_569093 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesRestart_569095(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesRestart_569094(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to restart a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569096 = path.getOrDefault("resourceGroupName")
  valid_569096 = validateParameter(valid_569096, JString, required = true,
                                 default = nil)
  if valid_569096 != nil:
    section.add "resourceGroupName", valid_569096
  var valid_569097 = path.getOrDefault("subscriptionId")
  valid_569097 = validateParameter(valid_569097, JString, required = true,
                                 default = nil)
  if valid_569097 != nil:
    section.add "subscriptionId", valid_569097
  var valid_569098 = path.getOrDefault("vmName")
  valid_569098 = validateParameter(valid_569098, JString, required = true,
                                 default = nil)
  if valid_569098 != nil:
    section.add "vmName", valid_569098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569099 = query.getOrDefault("api-version")
  valid_569099 = validateParameter(valid_569099, JString, required = true,
                                 default = nil)
  if valid_569099 != nil:
    section.add "api-version", valid_569099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569100: Call_VirtualMachinesRestart_569093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to restart a virtual machine.
  ## 
  let valid = call_569100.validator(path, query, header, formData, body)
  let scheme = call_569100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569100.url(scheme.get, call_569100.host, call_569100.base,
                         call_569100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569100, url, valid)

proc call*(call_569101: Call_VirtualMachinesRestart_569093;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesRestart
  ## The operation to restart a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569102 = newJObject()
  var query_569103 = newJObject()
  add(path_569102, "resourceGroupName", newJString(resourceGroupName))
  add(query_569103, "api-version", newJString(apiVersion))
  add(path_569102, "subscriptionId", newJString(subscriptionId))
  add(path_569102, "vmName", newJString(vmName))
  result = call_569101.call(path_569102, query_569103, nil, nil, nil)

var virtualMachinesRestart* = Call_VirtualMachinesRestart_569093(
    name: "virtualMachinesRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/restart",
    validator: validate_VirtualMachinesRestart_569094, base: "",
    url: url_VirtualMachinesRestart_569095, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStart_569104 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesStart_569106(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesStart_569105(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to start a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569107 = path.getOrDefault("resourceGroupName")
  valid_569107 = validateParameter(valid_569107, JString, required = true,
                                 default = nil)
  if valid_569107 != nil:
    section.add "resourceGroupName", valid_569107
  var valid_569108 = path.getOrDefault("subscriptionId")
  valid_569108 = validateParameter(valid_569108, JString, required = true,
                                 default = nil)
  if valid_569108 != nil:
    section.add "subscriptionId", valid_569108
  var valid_569109 = path.getOrDefault("vmName")
  valid_569109 = validateParameter(valid_569109, JString, required = true,
                                 default = nil)
  if valid_569109 != nil:
    section.add "vmName", valid_569109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569110 = query.getOrDefault("api-version")
  valid_569110 = validateParameter(valid_569110, JString, required = true,
                                 default = nil)
  if valid_569110 != nil:
    section.add "api-version", valid_569110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569111: Call_VirtualMachinesStart_569104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to start a virtual machine.
  ## 
  let valid = call_569111.validator(path, query, header, formData, body)
  let scheme = call_569111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569111.url(scheme.get, call_569111.host, call_569111.base,
                         call_569111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569111, url, valid)

proc call*(call_569112: Call_VirtualMachinesStart_569104;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesStart
  ## The operation to start a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569113 = newJObject()
  var query_569114 = newJObject()
  add(path_569113, "resourceGroupName", newJString(resourceGroupName))
  add(query_569114, "api-version", newJString(apiVersion))
  add(path_569113, "subscriptionId", newJString(subscriptionId))
  add(path_569113, "vmName", newJString(vmName))
  result = call_569112.call(path_569113, query_569114, nil, nil, nil)

var virtualMachinesStart* = Call_VirtualMachinesStart_569104(
    name: "virtualMachinesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/start",
    validator: validate_VirtualMachinesStart_569105, base: "",
    url: url_VirtualMachinesStart_569106, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListAvailableSizes_569115 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesListAvailableSizes_569117(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/vmSizes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesListAvailableSizes_569116(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all available virtual machine sizes to which the specified virtual machine can be resized.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569118 = path.getOrDefault("resourceGroupName")
  valid_569118 = validateParameter(valid_569118, JString, required = true,
                                 default = nil)
  if valid_569118 != nil:
    section.add "resourceGroupName", valid_569118
  var valid_569119 = path.getOrDefault("subscriptionId")
  valid_569119 = validateParameter(valid_569119, JString, required = true,
                                 default = nil)
  if valid_569119 != nil:
    section.add "subscriptionId", valid_569119
  var valid_569120 = path.getOrDefault("vmName")
  valid_569120 = validateParameter(valid_569120, JString, required = true,
                                 default = nil)
  if valid_569120 != nil:
    section.add "vmName", valid_569120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569121 = query.getOrDefault("api-version")
  valid_569121 = validateParameter(valid_569121, JString, required = true,
                                 default = nil)
  if valid_569121 != nil:
    section.add "api-version", valid_569121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569122: Call_VirtualMachinesListAvailableSizes_569115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes to which the specified virtual machine can be resized.
  ## 
  let valid = call_569122.validator(path, query, header, formData, body)
  let scheme = call_569122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569122.url(scheme.get, call_569122.host, call_569122.base,
                         call_569122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569122, url, valid)

proc call*(call_569123: Call_VirtualMachinesListAvailableSizes_569115;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesListAvailableSizes
  ## Lists all available virtual machine sizes to which the specified virtual machine can be resized.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569124 = newJObject()
  var query_569125 = newJObject()
  add(path_569124, "resourceGroupName", newJString(resourceGroupName))
  add(query_569125, "api-version", newJString(apiVersion))
  add(path_569124, "subscriptionId", newJString(subscriptionId))
  add(path_569124, "vmName", newJString(vmName))
  result = call_569123.call(path_569124, query_569125, nil, nil, nil)

var virtualMachinesListAvailableSizes* = Call_VirtualMachinesListAvailableSizes_569115(
    name: "virtualMachinesListAvailableSizes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/vmSizes",
    validator: validate_VirtualMachinesListAvailableSizes_569116, base: "",
    url: url_VirtualMachinesListAvailableSizes_569117, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
