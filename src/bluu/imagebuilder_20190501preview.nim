
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: VirtualMachineImageTemplate
## version: 2019-05-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Virtual Machine Image Template
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "imagebuilder"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563777 = ref object of OpenApiRestCall_563555
proc url_OperationsList_563779(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563778(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists available operations for the Microsoft.VirtualMachineImages provider
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563940 = query.getOrDefault("api-version")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "api-version", valid_563940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563963: Call_OperationsList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the Microsoft.VirtualMachineImages provider
  ## 
  let valid = call_563963.validator(path, query, header, formData, body)
  let scheme = call_563963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563963.url(scheme.get, call_563963.host, call_563963.base,
                         call_563963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563963, url, valid)

proc call*(call_564034: Call_OperationsList_563777; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the Microsoft.VirtualMachineImages provider
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564035 = newJObject()
  add(query_564035, "api-version", newJString(apiVersion))
  result = call_564034.call(nil, query_564035, nil, nil, nil)

var operationsList* = Call_OperationsList_563777(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.VirtualMachineImages/operations",
    validator: validate_OperationsList_563778, base: "", url: url_OperationsList_563779,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesList_564075 = ref object of OpenApiRestCall_563555
proc url_VirtualMachineImageTemplatesList_564077(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesList_564076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the VM image templates associated with the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564092 = path.getOrDefault("subscriptionId")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "subscriptionId", valid_564092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564093 = query.getOrDefault("api-version")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "api-version", valid_564093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564094: Call_VirtualMachineImageTemplatesList_564075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the VM image templates associated with the subscription.
  ## 
  let valid = call_564094.validator(path, query, header, formData, body)
  let scheme = call_564094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564094.url(scheme.get, call_564094.host, call_564094.base,
                         call_564094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564094, url, valid)

proc call*(call_564095: Call_VirtualMachineImageTemplatesList_564075;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineImageTemplatesList
  ## Gets information about the VM image templates associated with the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  var path_564096 = newJObject()
  var query_564097 = newJObject()
  add(query_564097, "api-version", newJString(apiVersion))
  add(path_564096, "subscriptionId", newJString(subscriptionId))
  result = call_564095.call(path_564096, query_564097, nil, nil, nil)

var virtualMachineImageTemplatesList* = Call_VirtualMachineImageTemplatesList_564075(
    name: "virtualMachineImageTemplatesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VirtualMachineImages/imageTemplates",
    validator: validate_VirtualMachineImageTemplatesList_564076, base: "",
    url: url_VirtualMachineImageTemplatesList_564077, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesListByResourceGroup_564098 = ref object of OpenApiRestCall_563555
proc url_VirtualMachineImageTemplatesListByResourceGroup_564100(protocol: Scheme;
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
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesListByResourceGroup_564099(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets information about the VM image templates associated with the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564101 = path.getOrDefault("subscriptionId")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "subscriptionId", valid_564101
  var valid_564102 = path.getOrDefault("resourceGroupName")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "resourceGroupName", valid_564102
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564103 = query.getOrDefault("api-version")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "api-version", valid_564103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564104: Call_VirtualMachineImageTemplatesListByResourceGroup_564098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the VM image templates associated with the specified resource group.
  ## 
  let valid = call_564104.validator(path, query, header, formData, body)
  let scheme = call_564104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564104.url(scheme.get, call_564104.host, call_564104.base,
                         call_564104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564104, url, valid)

proc call*(call_564105: Call_VirtualMachineImageTemplatesListByResourceGroup_564098;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualMachineImageTemplatesListByResourceGroup
  ## Gets information about the VM image templates associated with the specified resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564106 = newJObject()
  var query_564107 = newJObject()
  add(query_564107, "api-version", newJString(apiVersion))
  add(path_564106, "subscriptionId", newJString(subscriptionId))
  add(path_564106, "resourceGroupName", newJString(resourceGroupName))
  result = call_564105.call(path_564106, query_564107, nil, nil, nil)

var virtualMachineImageTemplatesListByResourceGroup* = Call_VirtualMachineImageTemplatesListByResourceGroup_564098(
    name: "virtualMachineImageTemplatesListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates",
    validator: validate_VirtualMachineImageTemplatesListByResourceGroup_564099,
    base: "", url: url_VirtualMachineImageTemplatesListByResourceGroup_564100,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesCreateOrUpdate_564119 = ref object of OpenApiRestCall_563555
proc url_VirtualMachineImageTemplatesCreateOrUpdate_564121(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageTemplateName" in path,
        "`imageTemplateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates/"),
               (kind: VariableSegment, value: "imageTemplateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesCreateOrUpdate_564120(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a virtual machine image template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_564139 = path.getOrDefault("imageTemplateName")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "imageTemplateName", valid_564139
  var valid_564140 = path.getOrDefault("subscriptionId")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "subscriptionId", valid_564140
  var valid_564141 = path.getOrDefault("resourceGroupName")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "resourceGroupName", valid_564141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564142 = query.getOrDefault("api-version")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "api-version", valid_564142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateImageTemplate operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_VirtualMachineImageTemplatesCreateOrUpdate_564119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a virtual machine image template
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_VirtualMachineImageTemplatesCreateOrUpdate_564119;
          imageTemplateName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## virtualMachineImageTemplatesCreateOrUpdate
  ## Create or update a virtual machine image template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateImageTemplate operation
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  var body_564148 = newJObject()
  add(path_564146, "imageTemplateName", newJString(imageTemplateName))
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  add(path_564146, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564148 = parameters
  result = call_564145.call(path_564146, query_564147, nil, nil, body_564148)

var virtualMachineImageTemplatesCreateOrUpdate* = Call_VirtualMachineImageTemplatesCreateOrUpdate_564119(
    name: "virtualMachineImageTemplatesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplatesCreateOrUpdate_564120,
    base: "", url: url_VirtualMachineImageTemplatesCreateOrUpdate_564121,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesGet_564108 = ref object of OpenApiRestCall_563555
proc url_VirtualMachineImageTemplatesGet_564110(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageTemplateName" in path,
        "`imageTemplateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates/"),
               (kind: VariableSegment, value: "imageTemplateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesGet_564109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about a virtual machine image template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_564111 = path.getOrDefault("imageTemplateName")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "imageTemplateName", valid_564111
  var valid_564112 = path.getOrDefault("subscriptionId")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "subscriptionId", valid_564112
  var valid_564113 = path.getOrDefault("resourceGroupName")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "resourceGroupName", valid_564113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564114 = query.getOrDefault("api-version")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "api-version", valid_564114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564115: Call_VirtualMachineImageTemplatesGet_564108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about a virtual machine image template
  ## 
  let valid = call_564115.validator(path, query, header, formData, body)
  let scheme = call_564115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564115.url(scheme.get, call_564115.host, call_564115.base,
                         call_564115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564115, url, valid)

proc call*(call_564116: Call_VirtualMachineImageTemplatesGet_564108;
          imageTemplateName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineImageTemplatesGet
  ## Get information about a virtual machine image template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564117 = newJObject()
  var query_564118 = newJObject()
  add(path_564117, "imageTemplateName", newJString(imageTemplateName))
  add(query_564118, "api-version", newJString(apiVersion))
  add(path_564117, "subscriptionId", newJString(subscriptionId))
  add(path_564117, "resourceGroupName", newJString(resourceGroupName))
  result = call_564116.call(path_564117, query_564118, nil, nil, nil)

var virtualMachineImageTemplatesGet* = Call_VirtualMachineImageTemplatesGet_564108(
    name: "virtualMachineImageTemplatesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplatesGet_564109, base: "",
    url: url_VirtualMachineImageTemplatesGet_564110, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesUpdate_564160 = ref object of OpenApiRestCall_563555
proc url_VirtualMachineImageTemplatesUpdate_564162(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageTemplateName" in path,
        "`imageTemplateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates/"),
               (kind: VariableSegment, value: "imageTemplateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesUpdate_564161(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the tags for this Virtual Machine Image Template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_564163 = path.getOrDefault("imageTemplateName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "imageTemplateName", valid_564163
  var valid_564164 = path.getOrDefault("subscriptionId")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "subscriptionId", valid_564164
  var valid_564165 = path.getOrDefault("resourceGroupName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "resourceGroupName", valid_564165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564166 = query.getOrDefault("api-version")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "api-version", valid_564166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters for Image Template update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564168: Call_VirtualMachineImageTemplatesUpdate_564160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the tags for this Virtual Machine Image Template
  ## 
  let valid = call_564168.validator(path, query, header, formData, body)
  let scheme = call_564168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564168.url(scheme.get, call_564168.host, call_564168.base,
                         call_564168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564168, url, valid)

proc call*(call_564169: Call_VirtualMachineImageTemplatesUpdate_564160;
          imageTemplateName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## virtualMachineImageTemplatesUpdate
  ## Update the tags for this Virtual Machine Image Template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Additional parameters for Image Template update.
  var path_564170 = newJObject()
  var query_564171 = newJObject()
  var body_564172 = newJObject()
  add(path_564170, "imageTemplateName", newJString(imageTemplateName))
  add(query_564171, "api-version", newJString(apiVersion))
  add(path_564170, "subscriptionId", newJString(subscriptionId))
  add(path_564170, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564172 = parameters
  result = call_564169.call(path_564170, query_564171, nil, nil, body_564172)

var virtualMachineImageTemplatesUpdate* = Call_VirtualMachineImageTemplatesUpdate_564160(
    name: "virtualMachineImageTemplatesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplatesUpdate_564161, base: "",
    url: url_VirtualMachineImageTemplatesUpdate_564162, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesDelete_564149 = ref object of OpenApiRestCall_563555
proc url_VirtualMachineImageTemplatesDelete_564151(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageTemplateName" in path,
        "`imageTemplateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates/"),
               (kind: VariableSegment, value: "imageTemplateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesDelete_564150(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a virtual machine image template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_564152 = path.getOrDefault("imageTemplateName")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "imageTemplateName", valid_564152
  var valid_564153 = path.getOrDefault("subscriptionId")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "subscriptionId", valid_564153
  var valid_564154 = path.getOrDefault("resourceGroupName")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "resourceGroupName", valid_564154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564155 = query.getOrDefault("api-version")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "api-version", valid_564155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_VirtualMachineImageTemplatesDelete_564149;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a virtual machine image template
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_VirtualMachineImageTemplatesDelete_564149;
          imageTemplateName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineImageTemplatesDelete
  ## Delete a virtual machine image template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564158 = newJObject()
  var query_564159 = newJObject()
  add(path_564158, "imageTemplateName", newJString(imageTemplateName))
  add(query_564159, "api-version", newJString(apiVersion))
  add(path_564158, "subscriptionId", newJString(subscriptionId))
  add(path_564158, "resourceGroupName", newJString(resourceGroupName))
  result = call_564157.call(path_564158, query_564159, nil, nil, nil)

var virtualMachineImageTemplatesDelete* = Call_VirtualMachineImageTemplatesDelete_564149(
    name: "virtualMachineImageTemplatesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplatesDelete_564150, base: "",
    url: url_VirtualMachineImageTemplatesDelete_564151, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesRun_564173 = ref object of OpenApiRestCall_563555
proc url_VirtualMachineImageTemplatesRun_564175(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageTemplateName" in path,
        "`imageTemplateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates/"),
               (kind: VariableSegment, value: "imageTemplateName"),
               (kind: ConstantSegment, value: "/run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesRun_564174(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create artifacts from a existing image template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_564176 = path.getOrDefault("imageTemplateName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "imageTemplateName", valid_564176
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
  ##              : Client Api Version.
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

proc call*(call_564180: Call_VirtualMachineImageTemplatesRun_564173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create artifacts from a existing image template
  ## 
  let valid = call_564180.validator(path, query, header, formData, body)
  let scheme = call_564180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564180.url(scheme.get, call_564180.host, call_564180.base,
                         call_564180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564180, url, valid)

proc call*(call_564181: Call_VirtualMachineImageTemplatesRun_564173;
          imageTemplateName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineImageTemplatesRun
  ## Create artifacts from a existing image template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564182 = newJObject()
  var query_564183 = newJObject()
  add(path_564182, "imageTemplateName", newJString(imageTemplateName))
  add(query_564183, "api-version", newJString(apiVersion))
  add(path_564182, "subscriptionId", newJString(subscriptionId))
  add(path_564182, "resourceGroupName", newJString(resourceGroupName))
  result = call_564181.call(path_564182, query_564183, nil, nil, nil)

var virtualMachineImageTemplatesRun* = Call_VirtualMachineImageTemplatesRun_564173(
    name: "virtualMachineImageTemplatesRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}/run",
    validator: validate_VirtualMachineImageTemplatesRun_564174, base: "",
    url: url_VirtualMachineImageTemplatesRun_564175, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesListRunOutputs_564184 = ref object of OpenApiRestCall_563555
proc url_VirtualMachineImageTemplatesListRunOutputs_564186(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageTemplateName" in path,
        "`imageTemplateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates/"),
               (kind: VariableSegment, value: "imageTemplateName"),
               (kind: ConstantSegment, value: "/runOutputs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesListRunOutputs_564185(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all run outputs for the specified Image Template resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_564187 = path.getOrDefault("imageTemplateName")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "imageTemplateName", valid_564187
  var valid_564188 = path.getOrDefault("subscriptionId")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "subscriptionId", valid_564188
  var valid_564189 = path.getOrDefault("resourceGroupName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "resourceGroupName", valid_564189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564190 = query.getOrDefault("api-version")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "api-version", valid_564190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564191: Call_VirtualMachineImageTemplatesListRunOutputs_564184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all run outputs for the specified Image Template resource
  ## 
  let valid = call_564191.validator(path, query, header, formData, body)
  let scheme = call_564191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564191.url(scheme.get, call_564191.host, call_564191.base,
                         call_564191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564191, url, valid)

proc call*(call_564192: Call_VirtualMachineImageTemplatesListRunOutputs_564184;
          imageTemplateName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineImageTemplatesListRunOutputs
  ## List all run outputs for the specified Image Template resource
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564193 = newJObject()
  var query_564194 = newJObject()
  add(path_564193, "imageTemplateName", newJString(imageTemplateName))
  add(query_564194, "api-version", newJString(apiVersion))
  add(path_564193, "subscriptionId", newJString(subscriptionId))
  add(path_564193, "resourceGroupName", newJString(resourceGroupName))
  result = call_564192.call(path_564193, query_564194, nil, nil, nil)

var virtualMachineImageTemplatesListRunOutputs* = Call_VirtualMachineImageTemplatesListRunOutputs_564184(
    name: "virtualMachineImageTemplatesListRunOutputs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}/runOutputs",
    validator: validate_VirtualMachineImageTemplatesListRunOutputs_564185,
    base: "", url: url_VirtualMachineImageTemplatesListRunOutputs_564186,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesGetRunOutput_564195 = ref object of OpenApiRestCall_563555
proc url_VirtualMachineImageTemplatesGetRunOutput_564197(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageTemplateName" in path,
        "`imageTemplateName` is a required path parameter"
  assert "runOutputName" in path, "`runOutputName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates/"),
               (kind: VariableSegment, value: "imageTemplateName"),
               (kind: ConstantSegment, value: "/runOutputs/"),
               (kind: VariableSegment, value: "runOutputName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesGetRunOutput_564196(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified run output for the specified image template resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   runOutputName: JString (required)
  ##                : The name of the run output
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_564198 = path.getOrDefault("imageTemplateName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "imageTemplateName", valid_564198
  var valid_564199 = path.getOrDefault("runOutputName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "runOutputName", valid_564199
  var valid_564200 = path.getOrDefault("subscriptionId")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "subscriptionId", valid_564200
  var valid_564201 = path.getOrDefault("resourceGroupName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "resourceGroupName", valid_564201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564202 = query.getOrDefault("api-version")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "api-version", valid_564202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564203: Call_VirtualMachineImageTemplatesGetRunOutput_564195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified run output for the specified image template resource
  ## 
  let valid = call_564203.validator(path, query, header, formData, body)
  let scheme = call_564203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564203.url(scheme.get, call_564203.host, call_564203.base,
                         call_564203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564203, url, valid)

proc call*(call_564204: Call_VirtualMachineImageTemplatesGetRunOutput_564195;
          imageTemplateName: string; runOutputName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualMachineImageTemplatesGetRunOutput
  ## Get the specified run output for the specified image template resource
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   runOutputName: string (required)
  ##                : The name of the run output
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564205 = newJObject()
  var query_564206 = newJObject()
  add(path_564205, "imageTemplateName", newJString(imageTemplateName))
  add(path_564205, "runOutputName", newJString(runOutputName))
  add(query_564206, "api-version", newJString(apiVersion))
  add(path_564205, "subscriptionId", newJString(subscriptionId))
  add(path_564205, "resourceGroupName", newJString(resourceGroupName))
  result = call_564204.call(path_564205, query_564206, nil, nil, nil)

var virtualMachineImageTemplatesGetRunOutput* = Call_VirtualMachineImageTemplatesGetRunOutput_564195(
    name: "virtualMachineImageTemplatesGetRunOutput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}/runOutputs/{runOutputName}",
    validator: validate_VirtualMachineImageTemplatesGetRunOutput_564196, base: "",
    url: url_VirtualMachineImageTemplatesGetRunOutput_564197,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
