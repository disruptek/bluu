
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: VirtualMachineImageTemplate
## version: 2019-02-01-preview
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  macServiceName = "imagebuilder"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593630 = ref object of OpenApiRestCall_593408
proc url_OperationsList_593632(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593631(path: JsonNode; query: JsonNode;
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
  var valid_593791 = query.getOrDefault("api-version")
  valid_593791 = validateParameter(valid_593791, JString, required = true,
                                 default = nil)
  if valid_593791 != nil:
    section.add "api-version", valid_593791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593814: Call_OperationsList_593630; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the Microsoft.VirtualMachineImages provider
  ## 
  let valid = call_593814.validator(path, query, header, formData, body)
  let scheme = call_593814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593814.url(scheme.get, call_593814.host, call_593814.base,
                         call_593814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593814, url, valid)

proc call*(call_593885: Call_OperationsList_593630; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the Microsoft.VirtualMachineImages provider
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593886 = newJObject()
  add(query_593886, "api-version", newJString(apiVersion))
  result = call_593885.call(nil, query_593886, nil, nil, nil)

var operationsList* = Call_OperationsList_593630(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.VirtualMachineImages/operations",
    validator: validate_OperationsList_593631, base: "", url: url_OperationsList_593632,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesList_593926 = ref object of OpenApiRestCall_593408
proc url_VirtualMachineImageTemplatesList_593928(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImageTemplatesList_593927(path: JsonNode;
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
  var valid_593943 = path.getOrDefault("subscriptionId")
  valid_593943 = validateParameter(valid_593943, JString, required = true,
                                 default = nil)
  if valid_593943 != nil:
    section.add "subscriptionId", valid_593943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593944 = query.getOrDefault("api-version")
  valid_593944 = validateParameter(valid_593944, JString, required = true,
                                 default = nil)
  if valid_593944 != nil:
    section.add "api-version", valid_593944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593945: Call_VirtualMachineImageTemplatesList_593926;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the VM image templates associated with the subscription.
  ## 
  let valid = call_593945.validator(path, query, header, formData, body)
  let scheme = call_593945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593945.url(scheme.get, call_593945.host, call_593945.base,
                         call_593945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593945, url, valid)

proc call*(call_593946: Call_VirtualMachineImageTemplatesList_593926;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineImageTemplatesList
  ## Gets information about the VM image templates associated with the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  var path_593947 = newJObject()
  var query_593948 = newJObject()
  add(query_593948, "api-version", newJString(apiVersion))
  add(path_593947, "subscriptionId", newJString(subscriptionId))
  result = call_593946.call(path_593947, query_593948, nil, nil, nil)

var virtualMachineImageTemplatesList* = Call_VirtualMachineImageTemplatesList_593926(
    name: "virtualMachineImageTemplatesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VirtualMachineImages/imageTemplates",
    validator: validate_VirtualMachineImageTemplatesList_593927, base: "",
    url: url_VirtualMachineImageTemplatesList_593928, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesListByResourceGroup_593949 = ref object of OpenApiRestCall_593408
proc url_VirtualMachineImageTemplatesListByResourceGroup_593951(protocol: Scheme;
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

proc validate_VirtualMachineImageTemplatesListByResourceGroup_593950(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets information about the VM image templates associated with the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593952 = path.getOrDefault("resourceGroupName")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = nil)
  if valid_593952 != nil:
    section.add "resourceGroupName", valid_593952
  var valid_593953 = path.getOrDefault("subscriptionId")
  valid_593953 = validateParameter(valid_593953, JString, required = true,
                                 default = nil)
  if valid_593953 != nil:
    section.add "subscriptionId", valid_593953
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593954 = query.getOrDefault("api-version")
  valid_593954 = validateParameter(valid_593954, JString, required = true,
                                 default = nil)
  if valid_593954 != nil:
    section.add "api-version", valid_593954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593955: Call_VirtualMachineImageTemplatesListByResourceGroup_593949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the VM image templates associated with the specified resource group.
  ## 
  let valid = call_593955.validator(path, query, header, formData, body)
  let scheme = call_593955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593955.url(scheme.get, call_593955.host, call_593955.base,
                         call_593955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593955, url, valid)

proc call*(call_593956: Call_VirtualMachineImageTemplatesListByResourceGroup_593949;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineImageTemplatesListByResourceGroup
  ## Gets information about the VM image templates associated with the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  var path_593957 = newJObject()
  var query_593958 = newJObject()
  add(path_593957, "resourceGroupName", newJString(resourceGroupName))
  add(query_593958, "api-version", newJString(apiVersion))
  add(path_593957, "subscriptionId", newJString(subscriptionId))
  result = call_593956.call(path_593957, query_593958, nil, nil, nil)

var virtualMachineImageTemplatesListByResourceGroup* = Call_VirtualMachineImageTemplatesListByResourceGroup_593949(
    name: "virtualMachineImageTemplatesListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates",
    validator: validate_VirtualMachineImageTemplatesListByResourceGroup_593950,
    base: "", url: url_VirtualMachineImageTemplatesListByResourceGroup_593951,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesCreateOrUpdate_593970 = ref object of OpenApiRestCall_593408
proc url_VirtualMachineImageTemplatesCreateOrUpdate_593972(protocol: Scheme;
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

proc validate_VirtualMachineImageTemplatesCreateOrUpdate_593971(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a virtual machine image template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_593990 = path.getOrDefault("imageTemplateName")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "imageTemplateName", valid_593990
  var valid_593991 = path.getOrDefault("resourceGroupName")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "resourceGroupName", valid_593991
  var valid_593992 = path.getOrDefault("subscriptionId")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "subscriptionId", valid_593992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593993 = query.getOrDefault("api-version")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "api-version", valid_593993
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

proc call*(call_593995: Call_VirtualMachineImageTemplatesCreateOrUpdate_593970;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a virtual machine image template
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_VirtualMachineImageTemplatesCreateOrUpdate_593970;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## virtualMachineImageTemplatesCreateOrUpdate
  ## Create or update a virtual machine image template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateImageTemplate operation
  var path_593997 = newJObject()
  var query_593998 = newJObject()
  var body_593999 = newJObject()
  add(path_593997, "imageTemplateName", newJString(imageTemplateName))
  add(path_593997, "resourceGroupName", newJString(resourceGroupName))
  add(query_593998, "api-version", newJString(apiVersion))
  add(path_593997, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593999 = parameters
  result = call_593996.call(path_593997, query_593998, nil, nil, body_593999)

var virtualMachineImageTemplatesCreateOrUpdate* = Call_VirtualMachineImageTemplatesCreateOrUpdate_593970(
    name: "virtualMachineImageTemplatesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplatesCreateOrUpdate_593971,
    base: "", url: url_VirtualMachineImageTemplatesCreateOrUpdate_593972,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesGet_593959 = ref object of OpenApiRestCall_593408
proc url_VirtualMachineImageTemplatesGet_593961(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImageTemplatesGet_593960(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about a virtual machine image template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_593962 = path.getOrDefault("imageTemplateName")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "imageTemplateName", valid_593962
  var valid_593963 = path.getOrDefault("resourceGroupName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "resourceGroupName", valid_593963
  var valid_593964 = path.getOrDefault("subscriptionId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "subscriptionId", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_VirtualMachineImageTemplatesGet_593959;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about a virtual machine image template
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_VirtualMachineImageTemplatesGet_593959;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineImageTemplatesGet
  ## Get information about a virtual machine image template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  var path_593968 = newJObject()
  var query_593969 = newJObject()
  add(path_593968, "imageTemplateName", newJString(imageTemplateName))
  add(path_593968, "resourceGroupName", newJString(resourceGroupName))
  add(query_593969, "api-version", newJString(apiVersion))
  add(path_593968, "subscriptionId", newJString(subscriptionId))
  result = call_593967.call(path_593968, query_593969, nil, nil, nil)

var virtualMachineImageTemplatesGet* = Call_VirtualMachineImageTemplatesGet_593959(
    name: "virtualMachineImageTemplatesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplatesGet_593960, base: "",
    url: url_VirtualMachineImageTemplatesGet_593961, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesUpdate_594011 = ref object of OpenApiRestCall_593408
proc url_VirtualMachineImageTemplatesUpdate_594013(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImageTemplatesUpdate_594012(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the tags for this Virtual Machine Image Template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_594014 = path.getOrDefault("imageTemplateName")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "imageTemplateName", valid_594014
  var valid_594015 = path.getOrDefault("resourceGroupName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "resourceGroupName", valid_594015
  var valid_594016 = path.getOrDefault("subscriptionId")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "subscriptionId", valid_594016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594017 = query.getOrDefault("api-version")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "api-version", valid_594017
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

proc call*(call_594019: Call_VirtualMachineImageTemplatesUpdate_594011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the tags for this Virtual Machine Image Template
  ## 
  let valid = call_594019.validator(path, query, header, formData, body)
  let scheme = call_594019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594019.url(scheme.get, call_594019.host, call_594019.base,
                         call_594019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594019, url, valid)

proc call*(call_594020: Call_VirtualMachineImageTemplatesUpdate_594011;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## virtualMachineImageTemplatesUpdate
  ## Update the tags for this Virtual Machine Image Template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Additional parameters for Image Template update.
  var path_594021 = newJObject()
  var query_594022 = newJObject()
  var body_594023 = newJObject()
  add(path_594021, "imageTemplateName", newJString(imageTemplateName))
  add(path_594021, "resourceGroupName", newJString(resourceGroupName))
  add(query_594022, "api-version", newJString(apiVersion))
  add(path_594021, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594023 = parameters
  result = call_594020.call(path_594021, query_594022, nil, nil, body_594023)

var virtualMachineImageTemplatesUpdate* = Call_VirtualMachineImageTemplatesUpdate_594011(
    name: "virtualMachineImageTemplatesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplatesUpdate_594012, base: "",
    url: url_VirtualMachineImageTemplatesUpdate_594013, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesDelete_594000 = ref object of OpenApiRestCall_593408
proc url_VirtualMachineImageTemplatesDelete_594002(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImageTemplatesDelete_594001(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a virtual machine image template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_594003 = path.getOrDefault("imageTemplateName")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "imageTemplateName", valid_594003
  var valid_594004 = path.getOrDefault("resourceGroupName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "resourceGroupName", valid_594004
  var valid_594005 = path.getOrDefault("subscriptionId")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "subscriptionId", valid_594005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594006 = query.getOrDefault("api-version")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "api-version", valid_594006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594007: Call_VirtualMachineImageTemplatesDelete_594000;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a virtual machine image template
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_VirtualMachineImageTemplatesDelete_594000;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineImageTemplatesDelete
  ## Delete a virtual machine image template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  add(path_594009, "imageTemplateName", newJString(imageTemplateName))
  add(path_594009, "resourceGroupName", newJString(resourceGroupName))
  add(query_594010, "api-version", newJString(apiVersion))
  add(path_594009, "subscriptionId", newJString(subscriptionId))
  result = call_594008.call(path_594009, query_594010, nil, nil, nil)

var virtualMachineImageTemplatesDelete* = Call_VirtualMachineImageTemplatesDelete_594000(
    name: "virtualMachineImageTemplatesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplatesDelete_594001, base: "",
    url: url_VirtualMachineImageTemplatesDelete_594002, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesRun_594024 = ref object of OpenApiRestCall_593408
proc url_VirtualMachineImageTemplatesRun_594026(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImageTemplatesRun_594025(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create artifacts from a existing image template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_594027 = path.getOrDefault("imageTemplateName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "imageTemplateName", valid_594027
  var valid_594028 = path.getOrDefault("resourceGroupName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "resourceGroupName", valid_594028
  var valid_594029 = path.getOrDefault("subscriptionId")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "subscriptionId", valid_594029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_594031: Call_VirtualMachineImageTemplatesRun_594024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create artifacts from a existing image template
  ## 
  let valid = call_594031.validator(path, query, header, formData, body)
  let scheme = call_594031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594031.url(scheme.get, call_594031.host, call_594031.base,
                         call_594031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594031, url, valid)

proc call*(call_594032: Call_VirtualMachineImageTemplatesRun_594024;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineImageTemplatesRun
  ## Create artifacts from a existing image template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  var path_594033 = newJObject()
  var query_594034 = newJObject()
  add(path_594033, "imageTemplateName", newJString(imageTemplateName))
  add(path_594033, "resourceGroupName", newJString(resourceGroupName))
  add(query_594034, "api-version", newJString(apiVersion))
  add(path_594033, "subscriptionId", newJString(subscriptionId))
  result = call_594032.call(path_594033, query_594034, nil, nil, nil)

var virtualMachineImageTemplatesRun* = Call_VirtualMachineImageTemplatesRun_594024(
    name: "virtualMachineImageTemplatesRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}/run",
    validator: validate_VirtualMachineImageTemplatesRun_594025, base: "",
    url: url_VirtualMachineImageTemplatesRun_594026, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesListRunOutputs_594035 = ref object of OpenApiRestCall_593408
proc url_VirtualMachineImageTemplatesListRunOutputs_594037(protocol: Scheme;
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

proc validate_VirtualMachineImageTemplatesListRunOutputs_594036(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all run outputs for the specified Image Template resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_594038 = path.getOrDefault("imageTemplateName")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "imageTemplateName", valid_594038
  var valid_594039 = path.getOrDefault("resourceGroupName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "resourceGroupName", valid_594039
  var valid_594040 = path.getOrDefault("subscriptionId")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "subscriptionId", valid_594040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594041 = query.getOrDefault("api-version")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "api-version", valid_594041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594042: Call_VirtualMachineImageTemplatesListRunOutputs_594035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all run outputs for the specified Image Template resource
  ## 
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_VirtualMachineImageTemplatesListRunOutputs_594035;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineImageTemplatesListRunOutputs
  ## List all run outputs for the specified Image Template resource
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  var path_594044 = newJObject()
  var query_594045 = newJObject()
  add(path_594044, "imageTemplateName", newJString(imageTemplateName))
  add(path_594044, "resourceGroupName", newJString(resourceGroupName))
  add(query_594045, "api-version", newJString(apiVersion))
  add(path_594044, "subscriptionId", newJString(subscriptionId))
  result = call_594043.call(path_594044, query_594045, nil, nil, nil)

var virtualMachineImageTemplatesListRunOutputs* = Call_VirtualMachineImageTemplatesListRunOutputs_594035(
    name: "virtualMachineImageTemplatesListRunOutputs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}/runOutputs",
    validator: validate_VirtualMachineImageTemplatesListRunOutputs_594036,
    base: "", url: url_VirtualMachineImageTemplatesListRunOutputs_594037,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesGetRunOutput_594046 = ref object of OpenApiRestCall_593408
proc url_VirtualMachineImageTemplatesGetRunOutput_594048(protocol: Scheme;
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

proc validate_VirtualMachineImageTemplatesGetRunOutput_594047(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified run output for the specified image template resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   runOutputName: JString (required)
  ##                : The name of the run output
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_594049 = path.getOrDefault("imageTemplateName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "imageTemplateName", valid_594049
  var valid_594050 = path.getOrDefault("resourceGroupName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "resourceGroupName", valid_594050
  var valid_594051 = path.getOrDefault("subscriptionId")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "subscriptionId", valid_594051
  var valid_594052 = path.getOrDefault("runOutputName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "runOutputName", valid_594052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594053 = query.getOrDefault("api-version")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "api-version", valid_594053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594054: Call_VirtualMachineImageTemplatesGetRunOutput_594046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified run output for the specified image template resource
  ## 
  let valid = call_594054.validator(path, query, header, formData, body)
  let scheme = call_594054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594054.url(scheme.get, call_594054.host, call_594054.base,
                         call_594054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594054, url, valid)

proc call*(call_594055: Call_VirtualMachineImageTemplatesGetRunOutput_594046;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; runOutputName: string): Recallable =
  ## virtualMachineImageTemplatesGetRunOutput
  ## Get the specified run output for the specified image template resource
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   runOutputName: string (required)
  ##                : The name of the run output
  var path_594056 = newJObject()
  var query_594057 = newJObject()
  add(path_594056, "imageTemplateName", newJString(imageTemplateName))
  add(path_594056, "resourceGroupName", newJString(resourceGroupName))
  add(query_594057, "api-version", newJString(apiVersion))
  add(path_594056, "subscriptionId", newJString(subscriptionId))
  add(path_594056, "runOutputName", newJString(runOutputName))
  result = call_594055.call(path_594056, query_594057, nil, nil, nil)

var virtualMachineImageTemplatesGetRunOutput* = Call_VirtualMachineImageTemplatesGetRunOutput_594046(
    name: "virtualMachineImageTemplatesGetRunOutput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}/runOutputs/{runOutputName}",
    validator: validate_VirtualMachineImageTemplatesGetRunOutput_594047, base: "",
    url: url_VirtualMachineImageTemplatesGetRunOutput_594048,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
